
Flight.transaction do

  CidPilot.find(:all).each do |cp|

#    file = File.open("/home/vihai/cids/" + cid.filename) 

    hgc = nil

    if cp.indirizzo && cp.indirizzo.size > 0
      hgc = GeoKit::Geocoders::MultiGeocoder.geocode(cp.indirizzo + ", " + cp.citta + ", " + cp.provincia + ", " + cp.nazione)

      puts "#{cp.cognome}: " + cp.indirizzo + "," + cp.citta + ", " + cp.provincia + ", " + cp.nazione + " ===> " + hgc.full_address

      if hgc.success
        home = Hel::Location.new
        home.address = hgc.street_address
        home.city = hgc.city
        home.zip = hgc.zip
        home.state = hgc.state
        home.country = hgc.country_code
        home.lat = hgc.lat
        home.lon = hgc.lng
        home.geocoder = hgc.provider
        home.geocode_precision = hgc.precision
      else
        home = Hel::Location.new
        home.address = cp.indirizzo
        home.city = cp.citta
        home.zip = cp.cap
        home.state = nil
        home.country = "IT"
        home.lat = nil
        home.lon = nil
        home.geocoder = nil
        home.geocode_precision = "address"
      end
    end

    person = Hel::Person.new
    person.name = Hel::Name.new(cp.nome, nil, cp.cognome)
    person.home_location = home
    person.tmp_telefono = cp.telefono
    person.tmp_cellulare = cp.cellulare
    person.save!

    if cp.email && cp.email.size > 0
      if !Hel::Identity.find_by_fqdn(cp.email)
        identity = Hel::Identity.new
        identity.fqdn = cp.email
        identity.password = cp.password
        identity.person = person
        identity.save!
      end
    end

    pilot = Pilot.new
    pilot.person = person
    pilot.club = Club.find_by_old_club_id(cp.id_club) || Club.find(792207131)
    pilot.fai_card = cp.tessera_fai
    pilot.gliding_license = cp.n_brevetto
    pilot.gliding_license_expiration = cp.scadenza_brev
    pilot.old_pilot_id = cp.id
    pilot.save!
  end
end
#
#
#    a = IgcFile.new(:file => file)
#
#    @flight = Flight.new(params[:flight])
#
#    igc_file = IgcFile.find(params[:flight][:igc_file_id])
#    igc_file.read_contents {}
#
#    @flight.igc_file = igc_file
#    @flight.update_from_igcfile
