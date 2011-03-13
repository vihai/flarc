module Csvva

class RegistrationController < ApplicationController

#  def show
#    if params[:fb_user]
############################### FIXME
##      @facebook_user.populate(:email, :first_name, :last_name)
#      @facebook_user = OpenStruct.new
#      render :template => 'registration/fb_show'
#    else
#      render :template => 'registration/show'
#    end
#  end

  def register
    # TODO: check validity password=password2, identity not present, etc...

    @identity = Ygg::Core::Identity.find_by_qualified(params[:email])
    if @identity
      render :template => 'csvva/registration/identity_already_present'
      return
    end

    Ygg::Core::Transaction.new 'Registration wizard' do

      password = Password.phonemic(8)

      person = Ygg::Core::Person.new(
          :first_name => params[:first_name],
          :middle_name => nil,
          :last_name => params[:last_name],
          :identities => [
             Ygg::Core::Identity.new(
               :qualified => params[:email],
               :is_admin => false,
               :credentials => [
                 Ygg::Core::Credential::ObfuscatedPassword.new(:password => password)
               ]
             )
           ]
        )

      pilot = Pilot.new(
          :person => person,
          :club => Club.find_by_symbol('acao')
        )

      if params[:fb_user]
        person.fb_uid = facebook_uid
      end

      person.save!
      pilot.save!

      Csvva::RegistrationNotifier.registration_complete(params[:email], password).deliver
      Csvva::RegistrationNotifier.new_pilot_registered(pilot).deliver
    end
  end

  def recover_password
    password = identity.credentials.first.password
    Cid::RegistrationNotifier.send_password(identity.qualified, password).deliver
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
