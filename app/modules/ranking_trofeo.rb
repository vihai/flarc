class RankingTrofeo < Ranking

  def self.compute

    results = {}

    ranking = Ranking.find_by_symbol(:csvva_tt_2011)

    Flight.joins(:flight_tags).joins(:tags).
           where('tags.symbol' => :csvva_2011, 'flight_tags.status' => 'approved').each do |flight|

      results[flight.pilot.id] ||= {}
      results[flight.pilot.id][:flights_count] ||= 0
      results[flight.pilot.id][:flights_count] += 1
    end

    # Pass 2: For each ranking update standings
    Ranking.transaction do

      ranking.generated_at = Time.now
      ranking.save!

      results.each do |pilot_id,pilot|

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

    return nil
  end

end
