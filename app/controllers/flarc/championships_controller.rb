module Flarc

class ChampionshipsController < RestController
  rest_controller_for Championship

  def subscribe
    if request.method == 'POST'
      req = ActiveSupport::JSON.decode(request.body).symbolize_keys!

      Ygg::Core::Transaction.new 'Registration wizard' do

        person = auth_person

        pilot = person.pilot || Pilot.new(:person => person)
        pilot.attributes = {
          :club => Club.find(req[:club_id]),
          :fai_card => req[:fai_card],
        }

        cid = Championship.find_by_symbol(:cid_2012)

        cp = pilot.championship_pilots.where(:championship_id => cid.id).first ||
               Championship::Pilot::Cid2012.new(:pilot => pilot, :championship => cid)
        cp.cid_category = req[:cid_category]
        cp.save!

        pilot.save!

        Notifier::Cid.new_pilot_registered(pilot)
      end

      respond_to do |format|
        format.json { render :json => { :success => true } }
      end
    end
  end
end

end