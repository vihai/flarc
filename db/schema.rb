# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20090428010101) do

  create_table "aaas", :force => true do |t|
    t.string    "title"
    t.text      "body"
    t.boolean   "published"
    t.timestamp "created_at"
    t.timestamp "updated_at"
  end

  create_table "alptherm_history_entries", :force => true do |t|
    t.timestamp "created_at"
    t.timestamp "updated_at"
    t.timestamp "taken_at",   :null => false
    t.integer   "source_id",  :null => false
    t.text      "data",       :null => false
  end

  create_table "alptherm_sources", :force => true do |t|
    t.string    "name"
    t.float     "lat"
    t.float     "lon"
    t.string    "site_param"
    t.timestamp "created_at"
    t.timestamp "updated_at"
  end

  create_table "cities", :force => true do |t|
    t.timestamp "created_at"
    t.timestamp "updated_at"
    t.string    "name",                      :null => false
    t.string    "name_foreign"
    t.string    "istat_id",     :limit => 6
    t.string    "fiscal_code",  :limit => 4
    t.integer   "province_id"
    t.string    "zip",          :limit => 8
    t.boolean   "is_capoluogo",              :null => false
    t.boolean   "suppressed",                :null => false
    t.integer   "country_id",                :null => false
  end

  create_table "clubs", :force => true do |t|
    t.string    "name"
    t.timestamp "created_at"
    t.timestamp "updated_at"
  end

  create_table "contact_areas", :force => true do |t|
    t.timestamp "created_at"
    t.timestamp "updated_at"
    t.string    "name",       :limit => 32
    t.text      "descr"
  end

  create_table "contact_roles", :force => true do |t|
    t.timestamp "created_at"
    t.timestamp "updated_at"
    t.string    "name",       :limit => 32
    t.text      "descr"
  end

  create_table "contacts", :force => true do |t|
    t.timestamp "created_at"
    t.timestamp "updated_at"
    t.integer   "identity_id"
    t.integer   "organization_id"
    t.integer   "contact_area_id"
    t.integer   "contact_role_id"
    t.text      "notes"
  end

  create_table "countries", :force => true do |t|
    t.timestamp "created_at"
    t.timestamp "updated_at"
    t.string    "a2",                       :limit => 2, :null => false
    t.string    "a3",                       :limit => 3, :null => false
    t.integer   "num",                                   :null => false
    t.string    "name",                                  :null => false
    t.string    "area_code",                :limit => 4
    t.boolean   "cities_are_authoritative"
  end

  add_index "countries", ["a2"], :name => "index_countries_on_a2", :unique => true
  add_index "countries", ["a3"], :name => "index_countries_on_a3", :unique => true
  add_index "countries", ["num"], :name => "index_countries_on_num", :unique => true

  create_table "credentials", :force => true do |t|
    t.timestamp "created_at"
    t.timestamp "updated_at"
    t.integer   "identity_id",               :null => false
    t.string    "scheme",      :limit => 32, :null => false
    t.string    "encoding",    :limit => 32, :null => false
    t.string    "diameter",    :limit => 32, :null => false
    t.text      "data",                      :null => false
  end

  add_index "credentials", ["diameter", "identity_id", "scheme"], :name => "index_credentials_on_identity_id_and_scheme_and_diameter"
  add_index "credentials", ["identity_id", "scheme"], :name => "index_credentials_on_identity_id_and_scheme"
  add_index "credentials", ["identity_id"], :name => "index_credentials_on_identity_id"

  create_table "flight_photos", :force => true do |t|
    t.timestamp "created_at"
    t.timestamp "updated_at"
    t.integer   "flight_id",                :null => false
    t.integer   "farm_id",                  :null => false
    t.integer   "server_id",                :null => false
    t.string    "photo_id",   :limit => 32, :null => false
    t.string    "secret",     :limit => 32, :null => false
    t.float     "lat"
    t.float     "lon"
  end

  create_table "flight_track_points", :force => true do |t|
    t.integer   "sequence",              :null => false
    t.integer   "flight_id",             :null => false
    t.timestamp "logtime",               :null => false
    t.float     "lat",                   :null => false
    t.float     "lon",                   :null => false
    t.string    "validity",              :null => false
    t.float     "press_alt"
    t.float     "gnss_alt"
    t.integer   "accuracy"
    t.integer   "sat_in_use"
    t.integer   "engine_noise"
    t.integer   "rpm"
    t.integer   "ground_speed"
    t.integer   "heading_mag"
    t.integer   "heading_true"
    t.integer   "ias"
    t.integer   "tas"
    t.integer   "total_energy_altitude"
    t.integer   "track_mag"
    t.integer   "track_true"
    t.integer   "vert_accuracy"
    t.float     "uncomp_vario"
    t.float     "comp_vario"
    t.integer   "wind_dir"
    t.integer   "wind_speed"
    t.timestamp "created_at"
    t.timestamp "updated_at"
  end

  create_table "flights", :force => true do |t|
    t.timestamp "created_at"
    t.timestamp "updated_at"
    t.integer   "pilot_id",                                                                                :null => false
    t.integer   "plane_id",                                                                                :null => false
    t.integer   "plane_type_configuration_id"
    t.timestamp "takeoff_time",                                                                            :null => false
    t.timestamp "landing_time",                                                                            :null => false
    t.float     "distance",                                                                                :null => false
    t.integer   "passenger_id"
    t.string    "status",                                    :default => "'unchecked'::character varying", :null => false
    t.boolean   "private",                                                                                 :null => false
    t.date      "logger_date"
    t.integer   "igc_file_id"
    t.string    "passenger_name",              :limit => 64
    t.text      "encoded_polyline_cache"
  end

  create_table "glider_classes", :force => true do |t|
    t.string    "name"
    t.timestamp "created_at"
    t.timestamp "updated_at"
  end

  create_table "group_members", :force => true do |t|
    t.timestamp "created_at"
    t.timestamp "updated_at"
  end

  create_table "groups", :force => true do |t|
    t.timestamp "created_at"
    t.timestamp "updated_at"
  end

  create_table "identities", :force => true do |t|
    t.timestamp "created_at"
    t.timestamp "updated_at"
    t.integer   "person_id"
    t.string    "fqdn",           :limit => 128,                    :null => false
    t.string    "password",       :limit => 32
    t.boolean   "email_verified"
    t.string    "uuid",           :limit => 22,                     :null => false
    t.boolean   "is_admin",                      :default => false, :null => false
    t.boolean   "privacy",                       :default => true,  :null => false
  end

  add_index "identities", ["fqdn"], :name => "index_identities_on_fqdn", :unique => true
  add_index "identities", ["person_id"], :name => "index_identities_on_person_id"
  add_index "identities", ["uuid"], :name => "index_identities_on_uuid", :unique => true

  create_table "igc_files", :force => true do |t|
    t.timestamp "created_at"
    t.timestamp "updated_at"
    t.integer   "flight_id"
    t.integer   "size"
    t.string    "content_type"
    t.string    "filename"
  end

  create_table "logs", :force => true do |t|
    t.timestamp "created_at"
    t.timestamp "updated_at"
    t.timestamp "log_time",                           :null => false
    t.integer   "identity_id",                        :null => false
    t.string    "operation",            :limit => 16
    t.string    "object_class_name"
    t.integer   "object_id"
    t.text      "descr",                              :null => false
    t.text      "changes"
    t.text      "notes"
    t.string    "http_remote_addr",     :limit => 64
    t.integer   "http_remote_port"
    t.string    "http_server_addr",     :limit => 64
    t.integer   "http_server_port"
    t.text      "http_host"
    t.text      "http_url"
    t.text      "http_user_agent"
    t.text      "http_referer"
    t.text      "http_x_forwarded_for"
    t.text      "http_via"
  end

  create_table "organizations", :force => true do |t|
    t.timestamp "created_at"
    t.timestamp "updated_at"
    t.string    "name"
    t.string    "ro_address"
    t.integer   "ro_city_id"
    t.string    "ro_zip",              :limit => 8
    t.string    "op_address"
    t.integer   "op_city_id"
    t.string    "op_zip",              :limit => 8
    t.string    "billing_address"
    t.integer   "billing_city_id"
    t.string    "billing_zip",         :limit => 8
    t.string    "vat_number",          :limit => 16
    t.string    "italian_fiscal_code", :limit => 16
    t.text      "notes"
  end

  create_table "people", :force => true do |t|
    t.timestamp "created_at"
    t.timestamp "updated_at"
    t.string    "first_name",          :limit => 64, :null => false
    t.string    "middle_name",         :limit => 64
    t.string    "last_name",           :limit => 64, :null => false
    t.string    "nickname",            :limit => 32
    t.string    "gender",              :limit => 1
    t.text      "home_address"
    t.integer   "home_city_id"
    t.string    "home_zip",            :limit => 10
    t.date      "birth_date"
    t.integer   "birth_city_id"
    t.string    "vat_number",          :limit => 16
    t.string    "italian_fiscal_code", :limit => 16
    t.text      "notes"
  end

  create_table "pilot_planes", :force => true do |t|
    t.timestamp "created_at"
    t.timestamp "updated_at"
    t.integer   "pilot_id"
    t.integer   "plane_id"
  end

  create_table "pilots", :force => true do |t|
    t.timestamp "created_at"
    t.timestamp "updated_at"
    t.integer   "person_id",  :null => false
    t.integer   "club_id"
  end

  create_table "plane_type_configurations", :force => true do |t|
    t.timestamp "created_at"
    t.timestamp "updated_at"
    t.string    "name",          :limit => 32, :null => false
    t.integer   "plane_type_id",               :null => false
    t.float     "handicap",                    :null => false
  end

  create_table "plane_types", :force => true do |t|
    t.timestamp "created_at"
    t.timestamp "updated_at"
    t.string    "manufacturer", :limit => 64, :null => false
    t.string    "name",         :limit => 32, :null => false
    t.integer   "seats"
    t.integer   "motor"
    t.float     "handicap"
    t.string    "link_wp"
  end

  create_table "planes", :force => true do |t|
    t.timestamp "created_at"
    t.timestamp "updated_at"
    t.string    "registration",  :limit => 8, :null => false
    t.integer   "plane_type_id",              :null => false
  end

  create_table "provinces", :force => true do |t|
    t.timestamp "created_at"
    t.timestamp "updated_at"
    t.string    "name"
    t.string    "short_name",    :limit => 2
    t.string    "istat_id",      :limit => 3
    t.integer   "region_id"
    t.string    "old_region_id"
  end

  create_table "ranking_history_entries", :force => true do |t|
    t.timestamp "created_at"
    t.timestamp "updated_at"
    t.integer   "ranking_member_id", :null => false
    t.timestamp "snapshot_time"
    t.integer   "position"
    t.float     "value"
    t.text      "data"
  end

  create_table "ranking_members", :force => true do |t|
    t.integer "ranking_id"
    t.integer "pilot_id"
    t.integer "position"
    t.float   "value"
    t.text    "data"
  end

  add_index "ranking_members", ["pilot_id", "ranking_id"], :name => "index_ranking_members_on_ranking_id_and_pilot_id", :unique => true
  add_index "ranking_members", ["pilot_id"], :name => "index_ranking_members_on_pilot_id"
  add_index "ranking_members", ["position"], :name => "ranking_members_position"
  add_index "ranking_members", ["ranking_id"], :name => "index_ranking_members_on_ranking_id"

  create_table "rankings", :force => true do |t|
    t.timestamp "created_at"
    t.timestamp "updated_at"
    t.string    "name"
    t.boolean   "official"
    t.integer   "priority"
    t.string    "color",        :limit => 6
    t.string    "driver",       :limit => 8
    t.timestamp "generated_at",              :null => false
  end

  create_table "regions", :force => true do |t|
    t.timestamp "created_at"
    t.timestamp "updated_at"
    t.string    "istat_id",   :limit => 2
    t.string    "name",                    :null => false
  end

  create_table "sessions", :force => true do |t|
    t.string    "session_id", :null => false
    t.text      "data"
    t.timestamp "created_at"
    t.timestamp "updated_at"
  end

  add_index "sessions", ["session_id"], :name => "index_sessions_on_session_id"
  add_index "sessions", ["updated_at"], :name => "index_sessions_on_updated_at"

end
