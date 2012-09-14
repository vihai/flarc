module Flarc
class Notifier

class Cid < ActionMailer::Base

  default :from => 'info@cidvv.it'

  raise_delivery_errors = true

  def registration_complete(destination, password)
    headers 'Auto-Submitted' => 'auto-generated',
            'X-Buoni-Cumuli' => 'YES'

    @email = destination
    @password = password

    mail(:to => destination,
         :subject => 'Registrazione al Campionato Italiano di Distanza').deliver
  end

  def new_pilot_registered(pilot)
    headers 'Auto-Submitted' => 'auto-generated'

    @pilot = pilot

    mail(:to => 'daniele@orlandi.com',
         :subject => 'Nuovo pilota registrato al CID').deliver
  end

  def send_password(destination, password)
    headers 'Auto-Submitted' => 'auto-generated'

    @email = destination
    @password = password

    mail(:to => destination,
         :subject => 'Password per il Campionato Italiano di Distanza').deliver
  end

  def championship_started(pilot)
    headers 'Auto-Submitted' => 'auto-generated'

    pilot.identities.each do |identity|
      next if identity.credentials.empty?

      @email = identity.qualified
      @password = identity.credentials.first.password # FIXME, choose the correct one

      mail(:to => identity.qualified,
           :subject => 'Campionato Italiano di Distanza 2012').deliver
    end
  end

end

end
end
