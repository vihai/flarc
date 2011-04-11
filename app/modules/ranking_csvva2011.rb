class RankingCsvva2011 < Ranking

  def RankingCsvva2011.compute

    ActiveRecord::Base.transaction do
    # Pass 1: Obtain all flights and organize them by ranking

    tags = Tag.find_by_symbol(:csvva_2011).flight_tags #.where(:status => :approved)

#    flights = Flight.select('flights.*, tags.id AS tag_id, championship_pilots.csvva_pilot_level AS pilot_level').
#                joins(:flight_tags).joins(:tags).joins(:pilot => { :championship_pilots => :championship }).
#                where("tags.symbol='csvva_2010' AND flight_tags.status='approved' AND championships.symbol='csvva_2010'").all


    results = {}
    tags.each do |tag|
      next if !tag.points

      flight = tag.flight
      pilot = flight.pilot
      championship_pilot = pilot.championship_pilots.find_by_championship_id(Championship.find_by_symbol(:csvva_2011))

      raise "Flight #{flight.id} Pilot '#{pilot.person.name}' not enrolled in championship" if !championship_pilot

      r = results[championship_pilot.csvva_pilot_level] ||= {}
      r[pilot.id] ||= {}

      r[pilot.id][:total_points] ||= 0
      r[pilot.id][:total_points] += tag.points || 0

      r[pilot.id][:flights] ||= Array.new
      fl_data = OpenStruct.new(flight.attributes)
      fl_data.points = tag.points
      r[pilot.id][:flights] << fl_data
    end

    # Pass 2: Compute points
    results.each do |pilot_level,result|
      result.each do |pilot_id,pilot|
        pilot[:flights].sort! { |a,b| b.points <=> a.points }
        pilot[:flights_best] = (pilot[:flights].sort { |a,b| b.points <=> b.points })[0..5]
      end
    end

    # Pass 3: Update standings
    results.each do |pilot_level,result|

#      Ranking.transaction do

        ranking = Ranking.find_by_symbol("csvva_#{pilot_level}_2011")
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

#          if standing.updated_at < Time.now - 10.minutes
#            standing.destroy
#            next
#          end

          standing.position = pos;
          standing.save!
        end
#      end
    end

    end #transaction

    return nil
  end

end
