#require 'httpclient'

namespace :chores do
  task :rankings => :environment do
    chore('Rankings') do
#      RankingBestThree.compute
#      RankingCsvva2010.compute
      RankingTrofeo.compute
#      RankingCirSpeed.compute
      RankingCsvva2011.compute
      RankingCid2011.compute
      RankingCid2011Club.compute
    end
  end

  task :snapshot => :environment do
    chore('Snapshot') do

      Ranking.transaction do
        Ranking.all.each do |ranking|
          ranking.standings.each do |standing|
            histentry = Ranking::Standing::HistoryEntry.new(
                          :standing => standing,
                          :snapshot_time => Time.now,
                          :position => standing.position,
                          :value => standing.value,
                          :data => standing.data)

            standing.history_entries << histentry
            standing.save!
          end

          ranking.club_standings.each do |standing|
            histentry = Ranking::ClubStanding::HistoryEntry.new(
                          :club_standing => standing,
                          :snapshot_time => Time.now,
                          :position => standing.position,
                          :value => standing.value,
                          :data => standing.data)

            standing.history_entries << histentry
            standing.save!
          end
        end
      end
    end
  end

  task :alptherm => :environment do
    chore('Alptherm') do
      client = HTTPClient.new

      AlpthermSource.all.each do |source|

        data = client.get_content('http://www.thomas-weiss.ch/cgi-bin/regthermsource.pl?' + source.site_param)

        if data.nil?
          puts 'HTTP client returned null'
          next
        end

        start = data.index('<PRE>') + 5
        stop = data.rindex('</PRE>')

        if start.nil? or stop.nil?
          puts 'Cannot find delimiters in alptherm'
          next
        end

        AlpthermHistoryEntry.create(
          :taken_at => Time.now,
          :source => source,
          :data => data[start..stop-1]
        )
      end

    end
  end

  

  task :hourly => :environment do
    chore('Hourly' ) do
      # Your Code Here
    end
  end

  task :daily => :environment do
    chore('Daily' ) do
      # Your Code Here
    end
  end

  task :weekly => :environment do
    chore('Weekly' ) do
      # Your Code Here
    end
  end

  def chore(name)
    puts "#{name} Task Invoked: #{Time.now}"
    yield
    puts "#{name} Task Finished: #{Time.now}"
  end
end

