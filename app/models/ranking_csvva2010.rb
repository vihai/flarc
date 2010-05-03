class RankingCsvva2010 < Ranking

  def RankingCsvva2010.compute
    results = Hash.new()

    # Pass 1: Obtain all flights and organize them by ranking
    flights = Flight.all(:select => "flights.*, rankings.id AS ranking_id",
                         :joins => "JOIN ranking_flights ON flights.id=ranking_flights.flight_id " +
                                   "JOIN rankings ON ranking_flights.ranking_id=rankings.id",
                         :conditions => "driver='csvva_2010' AND status='approved'")

    flights.each do |flight|
      next if !flight.points

      results[flight.ranking_id] ||= Hash.new
      results[flight.ranking_id][flight.pilot.id] ||= Hash.new

      results[flight.ranking_id][flight.pilot.id][:total_points] += flight.points

      results[flight.ranking_id][flight.pilot.id][:flights] ||= Array.new
      fl_data = OpenStruct.new(flight.attributes)
      fl_data.points = flight.points
      results[flight.ranking_id][flight.pilot.id][:flights] << fl_data
    end

    # Pass 2: Compute points
    results.each do |ranking_id,result|
      result.each do |pilot_id,pilot|
        pilot[:flights].sort! { |a,b| b.points <=> a.points }
        pilot[:flights_best] = (pilot[:flights].sort { |a,b| b.points <=> b.points })[0..5]
      end
    end

    # Pass 3: Update standings
    results.each do |ranking_id,result|

#      Ranking.transaction do

        ranking = Ranking.find(ranking_id)
        ranking.generated_at = Time.now
        ranking.save!

        result.each do |pilot_id,pilot|

          standing = ranking.standings.find_by_pilot_id(pilot_id) ||
                      RankingStanding.new(:ranking => ranking,
                                          :pilot_id => pilot_id)

          standing.data = { :flights_best => pilot[:flights_best] }
          standing.value = pilot[:flights_best].collect { |x| x.points }.sum

          ranking.standings << standing
        end

        pos = 0
        ranking.standings.all(:order => "value DESC, id ASC").each do |standing|

          pos += 1
          standing.position = pos;
          standing.save!
        end
#      end
    end

    return nil
  end

end
