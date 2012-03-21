module Flarc
class Ranking

class Cid2011 < Ranking

  def self.compute

    ActiveRecord::Base.transaction do
    # Pass 1: Obtain all flights and organize them by ranking

    results = {}

    cship = Championship.find_by_symbol(:cid_2011)

    cship.championship_flights.each do |cf|
      next if !cf.points

      flight = cf.flight
      pilot = flight.pilot
      championship_pilot = pilot.championship_pilots.find_by_championship_id(cship.id)

      raise "Pilot '#{pilot.person.name}' not enrolled in championship" if !championship_pilot

      results[cf.cid_ranking.to_sym] ||= {}
      results[cf.cid_ranking.to_sym][pilot.id] ||= {}

      results[cf.cid_ranking.to_sym][pilot.id][:total_points] ||= 0
      results[cf.cid_ranking.to_sym][pilot.id][:total_points] += cf.points || 0

      results[cf.cid_ranking.to_sym][pilot.id][:flights] ||= []
      results[cf.cid_ranking.to_sym][pilot.id][:flights] <<
        OpenStruct.new(:id => flight.id,
                       :pilot_id => flight.pilot_id,
                       :plane_id => flight.plane_id,
                       :private => flight.private,
                       :points => cf.points,
                       :status => cf.status)
    end

    # Pass 2: Compute points
    results.each do |ranking_sym,ranking_results|
      ranking_results.each do |pilot_id,pilot|
        pilot[:flights].sort! { |a,b| b.points <=> a.points }
        pilot[:flights_best] = (pilot[:flights].sort { |a,b| b.points <=> b.points })[0..2]
      end
    end

    # Pass 3: Update standings
    results.each do |ranking_sym,ranking_results|

      ranking = Ranking.find_by_symbol("cid_2011_#{ranking_sym}")
      ranking.generated_at = Time.now
      ranking.save!

      ranking_results.each do |pilot_id,pilot|

        standing = ranking.standings.find_by_pilot_id(pilot_id) ||
                    Ranking::Standing.new(:ranking => ranking,
                                        :pilot_id => pilot_id)

        standing.data = { :flights_best => pilot[:flights_best] }
        standing.value = pilot[:flights_best].collect { |x| x.points }.sum

        ranking.standings << standing
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
    end

    end #transaction

    return nil
  end

end

end
end
