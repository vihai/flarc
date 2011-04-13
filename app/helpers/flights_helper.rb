module FlightsHelper
  def fmt_duration(duration)
    return sprintf("%d:%02d", duration/3600, (duration/60) % 60)
  end

  def fmt_cid_ranking_to_name(ranking)
    case ranking.to_sym
    when :prom ; 'Promozione'
    when :naz_open ; 'Nazionale Open'
    when :naz_15m ; 'Nazionale 15 m'
    when :naz_13m3 ; 'Nazionale 13.5 m'
    when :naz_club ; 'Nazionale Club'
    end
  end
end
