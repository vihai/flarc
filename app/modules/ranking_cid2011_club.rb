class RankingCid2011Club < Ranking

  def self.compute

    ActiveRecord::Base.transaction do
    # Pass 1: Obtain all flights and group them by club

    results = {}

    cship = Championship.find_by_symbol(:cid_2011)

    cship.championship_flights.each do |cf|
      next if !cf.points

      flight = cf.flight
      club = flight.pilot.club
      championship_pilot = flight.pilot.championship_pilots.find_by_championship_id(cship.id)

      raise "Pilot '#{pilot.person.name}' not enrolled in championship" if !championship_pilot

      results[club.id] ||= {}

      results[club.id][:total_points] ||= 0
      results[club.id][:total_points] += cf.points || 0
    end

puts "AAAAAAAAAAAAA #{results.inspect}"
    # Pass 2: Update standings

    ranking = Ranking.find_by_symbol("cid_2011_club")
    ranking.generated_at = Time.now
    ranking.save!

    results.each do |club_id,result|

      standing = ranking.club_standings.find_by_club_id(club_id) ||
                  Ranking::ClubStanding.new(:ranking => ranking,
                                      :club_id => club_id)

      standing.value = result[:total_points]

      ranking.club_standings << standing
      standing.touch
    end

    pos = 0
    ranking.standings.all(:order => "value DESC, id ASC").each do |standing|

      if standing.updated_at < Time.now - 30.minutes
        standing.destroy
        next
      end

      pos += 1
      standing.position = pos;
      standing.save!
    end

    end #transaction

    return nil
  end

end
