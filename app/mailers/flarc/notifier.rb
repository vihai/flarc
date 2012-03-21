module Flarc

class Notifier < ActionMailer::Base

  default :from => 'daniele@orlandi.com'

  raise_delivery_errors = true

  def registration_complete(destination, password)
    headers 'Auto-Submitted' => 'auto-generated',
            'X-Buoni-Cumuli' => 'YES'

    @email = destination
    @password = password

    mail(:to => destination,
         :subject => 'Registrazione all\'archivio voli')
  end

  def new_pilot_registered(pilot)
    headers 'Auto-Submitted' => 'auto-generated'

    @pilot = pilot

    mail(:to => 'daniele@orlandi.com',
         :subject => 'Nuovo pilota registrato all\'archivio voli')
  end

  def send_password(destination, password)
    headers 'Auto-Submitted' => 'auto-generated'

    @email = destination
    @password = password

    mail(:to => destination,
         :subject => 'Password per l\'archivio voli')
  end

end

end
