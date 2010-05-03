
class RegistrationController < ApplicationController

  def show_form
    render
  end

  def register
    # TODO: check validity password=password2, identity not present, etc...


    ActiveRecord::Base.transaction do
      person = Hel::Person.new
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
      pilot.save!
    end

    redirect_to '/'
  end
end
