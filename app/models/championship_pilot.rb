class ChampionshipPilot < Ygg::BasicModel
  belongs_to :pilot,
             :class_name => 'Pilot'
  belongs_to :championship

  validates_presence_of :pilot, :championship

  attr_accessor :_subscribed

  def eql?(other)
    return false if !other.kind_of?(ChampionshipPilot)

    return self.pilot_id == other.pilot_id && self.championship_id == other.championship_id
  end

  def hash
    return self.pilot_id * self.championship_id
  end
end
