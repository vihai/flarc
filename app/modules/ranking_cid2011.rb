class RankingCid2011 < Ranking

  def self.compute

    ActiveRecord::Base.transaction do
    # Pass 1: Obtain all flights and organize them by ranking

    [ :cid_2011_naz_open, :cid_2011_naz_15m, :cid_2011_naz_13m5, :cid_2011_naz_club, :cid_2011_prom].each do |tag_symbol|
      tags = Tag.find_by_symbol(tag_symbol).flight_tags

      results = {}
      tags.each do |tag|
        next if !tag.points

        flight = tag.flight
        pilot = flight.pilot
        championship_pilot = pilot.championship_pilots.find_by_championship_id(Championship.find_by_symbol(:cid_2011))

        raise "Pilot '#{pilot.person.name}' not enrolled in championship" if !championship_pilot

        results[pilot.id] ||= {}

        results[pilot.id][:total_points] ||= 0
        results[pilot.id][:total_points] += tag.points || 0

        results[pilot.id][:flights] ||= Array.new
        fl_data = OpenStruct.new(flight.attributes)
        fl_data.points = tag.points
        results[pilot.id][:flights] << fl_data
      end

      # Pass 2: Compute points
      results.each do |pilot_id,pilot|
        pilot[:flights].sort! { |a,b| b.points <=> a.points }
        pilot[:flights_best] = (pilot[:flights].sort { |a,b| b.points <=> b.points })[0..2]
      end

      # Pass 3: Update standings
      ranking = Ranking.find_by_symbol(tag_symbol)
      ranking.generated_at = Time.now
      ranking.save!

      results.each do |pilot_id,pilot|

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

  #      if standing.updated_at < Time.now - 10.minutes
  #        standing.destroy
  #        next
  #      end

        standing.position = pos;
        standing.save!
      end

    end
    end #transaction

    return nil
  end

end
