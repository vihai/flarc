# coding: utf-8

class RegistrationController < ApplicationController

  def wizard
    catch :done do
      if request.method == 'GET'
        @state = {}
        @state[:state] = :email
        @state[:final] = false
      else
        @state = ActiveSupport::JSON.decode(params[:state]).symbolize_keys!
        @state[:state] = @state[:state].to_sym
        @state[:final] = false
  
        case @state[:state]
        when :email
 
          if params[:email].empty? && !(params[:email] =~ /\A[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,4}\z/)
            flash.now[:error] = "È necessario indicare un indirizzo e-mail valido"
            throw :done
          end
          @state[:email] = params[:email]
  
          @identity = Ygg::Core::Identity.find_by_qualified(params[:email])
          if @identity
            @state[:state] = :password
          else
            @state[:state] = :personal_data
          end
  
        when :password
  
          @state[:password] = params[:password]
  
  #        begin
            auth_token = Ygg::Core::HttpSession.attempt_authentication_by_fqda_and_password(
                             @state[:email], @state[:password])
  #        rescue FQDAFormat => e
  #          msg = e.message
  #          reason = :fqda_format_invalid
  #        else
  
          if auth_token
            @state[:state] = :done
          else
            flash.now[:error] = "Password non valida"
          end
  
        when :personal_data
          if params[:first_name].empty?
            flash.now[:error] = "Il nome è obbligatorio"
            throw :done
          end
          @state[:first_name] = params[:first_name]
  
          if params[:last_name].empty?
            flash.now[:error] = "Il cognome è obbligatorio"
            throw :done
          end
          @state[:last_name] = params[:last_name]

          identity = nil
          credential = nil

          @state[:state] = :done
        end
      end

      if @state[:state] == :done

        Ygg::Core::Transaction.new 'Registration wizard' do
  
          pilot = nil
  
          if @state[:password]
            # User is already registered
            auth_token = Ygg::Core::HttpSession.attempt_authentication_by_fqda_and_password(
                             @state[:email], @state[:password])

            identity = auth_token.identity
            credential = auth_token.credential
            person = identity.person
          else
            password = Password.phonemic(8)

            credential = Ygg::Core::Credential::ObfuscatedPassword.new(:password => password)
            identity = Ygg::Core::Identity.new(
                         :qualified => @state[:email],
                         :is_admin => false,
                         :credentials => [ credential ]
                       )
  
            person = Ygg::Core::Person.new(
                :first_name => @state[:first_name],
                :middle_name => nil,
                :last_name => @state[:last_name],
                :identities => [ identity ],
                :tmp_telefono => @state[:phone]
              )
          end
  
          if @state[:fb_user]
            person.fb_uid = facebook_uid
          end
  
          person.save!

          if current_site == :cid
            Cid::RegistrationNotifier.registration_complete(@state[:email], password).deliver
          elsif current_site == :csvva
            Csvva::RegistrationNotifier.registration_complete(@state[:email], password).deliver
          else
            RegistrationNotifier.registration_complete(@state[:email], password).deliver
          end
        end

        @asgard_session ||= Ygg::Core::HttpSession.create(request.env)
        @asgard_session.authenticated!(Ygg::Core::AuthenticationToken.new(
                 :identity => identity,
                 :confidence => :medium,
                 :credential => credential,
                 :method => :fqda_and_password))

        headers['X-Ygg-Session-Id'] = @asgard_session.uuid.to_s
        cookies['X-Ygg-Session-Id'] = @asgard_session.uuid.to_s

        if current_site == :cid
          redirect_to cid_registration_path
          return
        elsif current_site == :csvva
          redirect_to csvva_registration_path
          return
        end
      end
    end

    render :template => "registration/wizard/#{@state[:state]}"
  end

  def recover_password
    if request.method == 'GET'
    elsif request.method == 'POST'

      @fqda = params[:fqda]

      identity = Ygg::Core::Identity.find_by_qualified(params[:fqda])

      if !identity
        respond_to do |format|
          format.html { render :template => 'cid/registration/recover_password_identity_not_found' }
          format.js { render(:update) { |page| page.alert 'Indirizzo e-mail non trovato' } }
        end

        return
      end

      if identity.credentials.empty?
        Ygg::Core::Transaction.new 'Password auto-generated' do
          identity.credentials << Ygg::Core::Credential::ObfuscatedPassword.new(:password => Password.phonemic(8))
          identity.save!
        end
      end

      password = identity.credentials.first.password
      Cid::RegistrationNotifier.send_password(identity.qualified, password).deliver

      respond_to do |format|
        format.html { render :template => 'cid/registration/recover_password_done' }
        format.js { render(:update) { |page| page.alert 'La password è stata inviata via e-mail' } }
      end
    end
  end

#  def login_and_associate
#
#    identity = Hel::Identity.find_by_fqdn(params[:email])
#
#    if !identity.nil? && identity.password == params[:password]
#      identity.person.fb_uid = facebook_uid
#      identity.person.save!
#
#      authenticated!(:facebook, identity.person, identity)
#    end
#
#    redirect_to '/'
#  end
end

