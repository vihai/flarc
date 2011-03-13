module Csvva

class RegistrationNotifier < ActionMailer::Base
  default :from => 'info@csvva.it'

  raise_delivery_errors = true

  def registration_complete(destination, password)
    headers 'Auto-Submitted' => 'auto-generated',
            'X-Buoni-Cumuli' => 'YES'

    @email = destination
    @password = password

    mail(:to => destination,
         :subject => 'Registrazione al Campionato CSVVA di Distanza')
  end

  def new_pilot_registered(pilot)
    headers 'Auto-Submitted' => 'auto-generated'

    @pilot = pilot

    mail(:to => 'voli@csvva.it',
         :subject => 'Nuovo pilota registrato al Campionato CSVVA di Distanza')
  end

  def send_password(destination, password)
    headers 'Auto-Submitted' => 'auto-generated'

    @email = destination
    @password = password

    mail(:to => destination,
         :subject => 'Password per il Campionato CSVVA di Distanza')
  end

end

end
