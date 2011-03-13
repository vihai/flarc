# coding: utf-8

module Cid

class RegistrationController < ApplicationController

  def wizard
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
          @state[:state] = :championship_data
        else
          flash[:notice] = "Password non valida"
        end

      when :personal_data
        @state[:first_name] = params[:first_name]
        @state[:last_name] = params[:last_name]
        @state[:state] = :championship_data
      when :championship_data
        @state[:fai_card] = params[:fai_card]
        @state[:club_id] = params[:club_id]
        @state[:cid_category] = params[:cid_category]
        @state[:state] = :finish

        Ygg::Core::Transaction.new 'Registration wizard' do

          pilot = nil

          if @state[:password]
            # User is already registered
            auth_token = Ygg::Core::HttpSession.attempt_authentication_by_fqda_and_password(
                             @state[:email], @state[:password])

            person = auth_token.identity.person

            pilot_attrs = {
                :club => Club.find(@state[:club_id]),
                :fai_card => @state[:fai_card],
            }

            pilot = person.pilot || Pilot.new
            person.pilot.attributes = pilot_attrs

          else
            password = Password.phonemic(8)

            person = Ygg::Core::Person.new(
                :first_name => @state[:first_name],
                :middle_name => nil,
                :last_name => @state[:last_name],
                :identities => [
                   Ygg::Core::Identity.new(
                     :qualified => @state[:email],
                     :is_admin => false,
                     :credentials => [
                       Ygg::Core::Credential::ObfuscatedPassword.new(:password => password)
                     ]
                   )
                 ],
                :tmp_telefono => @state[:phone]
              )

            pilot = Pilot.new(
                :person => person,
                :club => Club.find(@state[:club_id]),
                :fai_card => @state[:fai_card],
              )
          end

          cid = Championship.find_by_symbol(:cid_2011)

          cp = pilot.championship_pilots.where(:championship_id => cid.id).first ||
                 ChampionshipPilot.new(:pilot => pilot, :championship => cid)
          cp.cid_category = @state[:cid_category]
          cp.save!

          if @state[:fb_user]
            person.fb_uid = facebook_uid
          end

          person.save!
          pilot.save!

          Cid::RegistrationNotifier.registration_complete(@state[:email], password).deliver
          Cid::RegistrationNotifier.new_pilot_registered(pilot).deliver
        end
      end
    end

    render :template => "cid/registration/registration_wizard_#{@state[:state]}"
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

  def login_and_associate

    identity = Hel::Identity.find_by_fqdn(params[:email])

    if !identity.nil? && identity.password == params[:password]
      identity.person.fb_uid = facebook_uid
      identity.person.save!

      authenticated!(:facebook, identity.person, identity)
    end

    redirect_to '/'
  end
end

end
