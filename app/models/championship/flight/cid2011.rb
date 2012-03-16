class Championship
class Flight

class Cid2011 < Flight
  attr_accessor :task_eval
  attr_accessor :task_type

  validates_inclusion_of :cid_ranking, :in => [ :prom, :naz_open, :naz_15m, :naz_13m5, :naz_club ]
  validates_presence_of :cid_ranking

  validates_inclusion_of :task_eval, :in => [ :free, :not_completed, :completed ]
  validates_presence_of :task_eval

  validates_inclusion_of :task_type, :in => [ :butterfly, :simple_triangle, :round_trip,
                                              :fai_triangle, :straight_line ]
  validates_presence_of :task_type

  validates_presence_of :distance
  validates_numericality_of :distance

  after_initialize do
    if !new_record?
      self.data ||= {}
      self.task_eval = self.data[:task_eval]
      self.task_type = self.data[:task_type]
      self.cid_ranking = self.cid_ranking.to_sym
    end
  end

  before_validation do
    self.task_type = self.task_type.to_sym
    self.task_eval = self.task_eval.to_sym
    self.cid_ranking = self.cid_ranking.to_sym
  end

  before_save do
    nd = {}
    self.data ||= {}
    self.data.each { |k,v| nd[k.to_sym] = v }
    self.data = nd
    self.data[:task_eval] = self.task_eval.to_sym
    self.data[:task_type] = self.task_type.to_sym
  end

  def handicap
    return (self.flight.plane_type_configuration ?
              self.flight.plane_type_configuration.handicap :
              self.flight.plane.plane_type.handicap)
  end

  def club_handicap
    return (self.flight.plane_type_configuration ?
              self.flight.plane_type_configuration.club_handicap :
              self.flight.plane.plane_type.club_handicap)
  end

  def points
    return nil if !distance

    if self.championship.symbol.to_sym == :cid_2011 &&
       self.cid_ranking.to_sym == :naz_club
      hcap = club_handicap
    else
      hcap = handicap
    end

    return nil if !hcap

    pts = (distance / 1000.0) / hcap

    case self.task_type
    when :round_trip ; pts = pts * 1.3
    when :fai_triangle ; pts = pts * 1.4
    when :straight_line ; pts = pts * 1.6
    when :simple_triangle
      if task_eval != :free
        pts = pts * 1.2
      end
    end

    if task_eval == :completed
      pts = pts * 1.1
    end

    pts
  end
end

end
end
