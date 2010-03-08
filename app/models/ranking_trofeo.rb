class RankingTrofeo < Ranking

  def self.compute
    results = Hash.new()

    # Iterate all flights and calculate each ranking result
    flights = Flight.all(:select => "flights.*, rankings.id AS ranking_id",
                         :joins => "JOIN ranking_flights ON flights.id=ranking_flights.flight_id " +
                                   "JOIN rankings ON ranking_flights.ranking_id=rankings.id",
                         :conditions => "driver='trofeo' AND status='approved'")

    flights.each do |flight|
      results[flight.ranking_id] ||= Hash.new
      results[flight.ranking_id][flight.pilot.id] ||= Hash.new
      results[flight.ranking_id][flight.pilot.id][:flights_count] += 1
    end

    # Pass 2: For each ranking update standings
    results.each do |ranking_id,result|

      Ranking.transaction do

        ranking = Ranking.find(ranking_id)
        ranking.generated_at = Time.now
        ranking.save!

        result.each do |pilot_id,pilot|

          standing = ranking.standings.find_by_pilot_id(pilot_id) ||
                      RankingStanding.new(:ranking => ranking,
                                          :pilot_id => pilot_id)

          standing.value = pilot[:flights_count] || 0

          ranking.standings << standing
        end

        # Pass 3: Update standing positions
        pos = 0
        prev_value = nil
        ranking.standings.find(:all,
                   :order => "value DESC, id ASC").each do |standing|

          if (!prev_value || standing.value != prev_value)
            pos += 1
            prev_value = standing.value
          end

          standing.position = pos;
          standing.save!
        end
      end
    end

    return nil
  end

end
