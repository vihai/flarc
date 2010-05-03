
Flight.transaction do
 cnt = 1

  CidFlight.all.each do |x|

    puts "################## doing N=#{cnt+=1} ID=#{x.id} IDVolo=#{x.id_volo} OldPilot=#{x.id_pilota} ############# "

    f = Flight.new

    igcfile = IgcFile.find_by_igc_filename(x.file_igc)
    if igcfile
      puts "Reding #{x.file_igc}"
      f.igc_file = igcfile
      f.igc_file.read_contents { }
      f.update_from_igcfile
    else
      puts "No IGC file"
      f.takeoff_time = x.data;
      f.landing_time = x.data;
    end

    f.pilot = Pilot.find_by_old_pilot_id(x.id_pilota)

    if !f.pilot
      puts "Pilot not found"
      next
    end

    f.plane = Plane.find_by_registration("D-0000")
    f.distance = x.km
    f.status = "pending"
    f.private = false
    f.tmp_id = x.id
    f.tmp_cid_id = x.id_volo
    f.tmp_date = x.data
    f.tmp_glider = x.aliante
    f.tmp_fca = x.fca
    f.tmp_classe = x.classe
    f.tmp_tipo_volo = x.tipo_volo
    f.tmp_fcv = x.fcv
    f.tmp_punti = x.punti
    f.tmp_approvazione = x.approvazione
    f.tmp_primato = x.primato
    f.tmp_aeroporto = x.aeroporto
    f.tmp_pena = x.pena

    f.save!
  end
end
