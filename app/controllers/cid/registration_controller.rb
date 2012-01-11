# coding: utf-8

module Cid

class RegistrationController < ApplicationController

  def wizard
    if !hel_session || !hel_session.authenticated?
      render :template => "csvva/registration/wizard/permanent_error"
      return
    end

    catch :done do
      if request.method == 'GET'
        @state = {}
        @state[:state] = :championship_data
        @state[:final] = false
      else
        @state = ActiveSupport::JSON.decode(params[:state]).symbolize_keys!
        @state[:state] = @state[:state].to_sym
        @state[:final] = false

        case @state[:state]
        when :championship_data
          if params[:fai_card].empty? || !(params[:fai_card] =~ /^[0-9]+$/)
            flash.now[:error] = "È necessario specificare un numero di tessera FAI valido"
            throw :done
          end
          @state[:fai_card] = params[:fai_card]

          if params[:club_id].empty?
            flash.now[:error] = "È necessario specificare un CLUB di appartenenza"
            throw :done
          end
          @state[:club_id] = params[:club_id]

          if params[:cid_category].empty?
            flash.now[:error] = "È necessario selezionare la propria categoria"
            throw :done
          end
          @state[:cid_category] = params[:cid_category]

          @state[:state] = :finish

          Ygg::Core::Transaction.new 'Registration wizard' do

            person = auth_person

            pilot = person.pilot || Pilot.new(:person => person)
            pilot.attributes = {
              :club => Club.find(@state[:club_id]),
              :fai_card => @state[:fai_card],
            }

            cid = Championship.find_by_symbol(:cid_2011)

            cp = pilot.championship_pilots.where(:championship_id => cid.id).first ||
                   Championship::Pilot::Cid2011.new(:pilot => pilot, :championship => cid)
            cp.cid_category = @state[:cid_category]
            cp.save!

            pilot.save!

            Cid::RegistrationNotifier.new_pilot_registered(pilot).deliver
          end

          @state[:state] = :done
        end
      end
    end

    render :template => "cid/registration/wizard/#{@state[:state]}"
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
