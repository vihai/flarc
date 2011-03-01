
class RegistrationController < ApplicationController

  def show
    if params[:fb_user]
############################## FIXME
#      @facebook_user.populate(:email, :first_name, :last_name)
      @facebook_user = OpenStruct.new
      render :template => 'registration/fb_show'
    else
      render :template => 'registration/show'
    end
  end

  def register
    # TODO: check validity password=password2, identity not present, etc...

    ActiveRecord::Base.transaction do
      person = Person.new
      person.name = Hel::Name.new(params[:first_name], nil, params[:last_name])
      person.save!

      if params[:email] != ''
        identity = Hel::Identity.new
        identity.fqdn = params[:email]
        identity.password = params[:password]
        identity.person = person
        identity.save!
      end

      pilot = Pilot.new
      pilot.person = person
      pilot.club = Club.find(params[:club_id])

      if params[:fb_user]
        person.fb_uid = facebook_uid
      end

      pilot.save!
    end

    redirect_to '/'
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
