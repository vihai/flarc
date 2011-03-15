# coding: utf-8

module Csvva

class RegistrationController < ApplicationController

  def wizard
    if !asgard_session || !asgard_session.authenticated?
      render :template => "csvva/registration/wizard/permanent_error"
      return
    end

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
        @state[:csvva_category] = params[:csvva_category]

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

          csvva = Championship.find_by_symbol(:csvva_2011)

          cp = pilot.championship_pilots.where(:championship_id => csvva.id).first ||
                 ChampionshipPilot.new(:pilot => pilot, :championship => csvva)
          cp.csvva_category = @state[:csvva_category]
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

    render :template => "csvva/registration/wizard/#{@state[:state]}"
  end

  def recover_password
    if request.method == 'GET'
    elsif request.method == 'POST'

      @fqda = params[:fqda]

      identity = Ygg::Core::Identity.find_by_qualified(params[:fqda])

      if !identity
        respond_to do |format|
          format.html { render :template => 'csvva/registration/recover_password_identity_not_found' }
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
        format.html { render :template => 'csvva/registration/recover_password_done' }
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
