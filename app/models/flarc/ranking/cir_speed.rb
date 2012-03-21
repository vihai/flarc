module Flarc
class Ranking

class CirSpeed < Ranking

  def self.compute
    results = Hash.new()

    flights = Flight.all(:select => "flights.*, rankings.id AS ranking_id",
                         :joins => "JOIN ranking_flights ON flights.id=ranking_flights.flight_id " +
                                   "JOIN rankings ON ranking_flights.ranking_id=rankings.id",
                         :conditions => "driver='cir_speed' AND status='approved'")

    flights.each do |flight|
      if flight.speed.nil?
        puts "Flight #{flight.id} missing speed" 
        next
      end

      if flight.handicap.nil?
        puts "Flight #{flight.id} missing handicap"
        next
      end

      speed = flight.speed / flight.handicap

      results[flight.ranking_id] ||= Hash.new
      results[flight.ranking_id][flight.id] ||= Hash.new
      results[flight.ranking_id][flight.id][:speed] = speed 

      if !results[flight.ranking_id][:max_speed] || speed > results[flight.ranking_id][:max_speed]
        results[flight.ranking_id][:max_speed] = speed 
      end
    end

    results.each do |ranking_id,results_ranking|

      Ranking.transaction do

        ranking = Ranking.find(ranking_id)
        ranking.generated_at = Time.now
        ranking.save!

        ranking.flights.each do |flight|

          next if !results_ranking[flight.id]

          standing = ranking.standings.find_by_flight_id(flight.id) ||
                      Ranking::Standing.new(:ranking => ranking, :flight => flight)
          standing.value = (results_ranking[flight.id][:speed] / results_ranking[:max_speed]) * 1000
          standing.pilot = flight.pilot # Pilot may change due to corrections in the DB

          ranking.standings << standing
        end

        pos = 0
        ranking.standings.find(:all,
                   :order => "value DESC, id ASC").each do |standing|

          pos += 1
          standing.position = pos;
          standing.save!
        end
      end
    end

    return nil
  end

end

end
end
