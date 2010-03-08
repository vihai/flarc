module FlightsHelper
  def fmt_duration(duration)
    return sprintf("%d:%02d", duration/3600, (duration/60) % 60)
  end
end
