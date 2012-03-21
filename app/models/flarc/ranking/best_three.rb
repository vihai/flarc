module Flarc
class Ranking

class BestThree < Ranking

  def self.compute
    results = Hash.new()

    # Pass 1: Obtain all flights and organize them by ranking
    flights = Flight.all(:select => "flights.*, rankings.id AS ranking_id",
                         :joins => "JOIN ranking_flights ON flights.id=ranking_flights.flight_id " +
                                   "JOIN rankings ON ranking_flights.ranking_id=rankings.id",
                         :conditions => "driver='best3' AND status='approved'")

    flights.each do |flight|
      next if !flight.points

      results[flight.ranking_id] ||= Hash.new
      results[flight.ranking_id][flight.pilot.id] ||= Hash.new

      results[flight.ranking_id][flight.pilot.id][:total_points] += flight.points

      results[flight.ranking_id][flight.pilot.id][:flights] ||= Array.new
      results[flight.ranking_id][flight.pilot.id][:flights] << flight
    end

    # Pass 2: Compute points
    results.each do |ranking_id,result|
      result.each do |pilot_id,pilot|
        pilot[:flights].sort! { |a,b| b.points <=> a.points }

        # Take the best flights after June
        best = (pilot[:flights].select { |a|
                  a.takeoff_time >= Time.utc(2009,6,1) })[0..5]

        # Take at most three flights before June
        best += (pilot[:flights].select { |a|
                  a.takeoff_time < Time.utc(2009,6,1) }.
                    sort { |a,b| b.points <=> a.points })[0..2]

        pilot[:flights_best] = (best.sort { |a,b| b.points <=> a.points })[0..5]
      end
    end

    # Pass 3: Update standings
    results.each do |ranking_id,result|

      Ranking.transaction do

        ranking = Ranking.find(ranking_id)
        ranking.generated_at = Time.now
        ranking.save!

        result.each do |pilot_id,pilot|

          standing = ranking.standings.find_by_pilot_id(pilot_id) ||
                      Ranking::Standing.new(:ranking => ranking,
                                          :pilot_id => pilot_id)

          standing.data =  { :flights_best => pilot[:flights_best] }
          standing.value = pilot[:flights_best].collect { |x| x.points }.sum

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
