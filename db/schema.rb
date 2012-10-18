# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20121010192150) do

  create_table "a", :id => false, :force => true do |t|
    t.integer "a"
  end

  create_table "alptherm_history_entries", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "taken_at",   :null => false
    t.integer  "source_id",  :null => false
    t.text     "data",       :null => false
  end

  create_table "alptherm_sources", :force => true do |t|
    t.string   "name"
    t.float    "lat"
    t.float    "lon"
    t.string   "site_param"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "uuid",       :limit => 36
  end

  create_table "attic_cid_flights", :force => true do |t|
    t.integer "id_volo",                    :default => 0,  :null => false
    t.integer "id_pilota",                  :default => 0,  :null => false
    t.date    "data"
    t.string  "aliante",      :limit => 40, :default => "", :null => false
    t.float   "fca",                                        :null => false
    t.string  "classe",       :limit => 40, :default => "", :null => false
    t.string  "tipo_volo",    :limit => 40, :default => "", :null => false
    t.float   "fcv",                                        :null => false
    t.float   "km",                                         :null => false
    t.float   "punti",                                      :null => false
    t.integer "approvazione",               :default => 0,  :null => false
    t.integer "primato",                    :default => 0,  :null => false
    t.string  "aeroporto",    :limit => 40, :default => "", :null => false
    t.string  "file_igc",     :limit => 40, :default => "", :null => false
    t.integer "pena"
  end

  create_table "attic_cid_pilots", :force => true do |t|
    t.string  "cognome",            :limit => 40, :default => "", :null => false
    t.string  "nome",               :limit => 40, :default => "", :null => false
    t.integer "id_club",                          :default => 0,  :null => false
    t.string  "club",               :limit => 20, :default => "", :null => false
    t.string  "password",                         :default => "", :null => false
    t.string  "username",           :limit => 40, :default => "", :null => false
    t.text    "indirizzo",                        :default => "", :null => false
    t.string  "citta",              :limit => 30, :default => "", :null => false
    t.string  "provincia",          :limit => 2,  :default => "", :null => false
    t.string  "nazione",            :limit => 20, :default => "", :null => false
    t.string  "cap",                :limit => 10, :default => "", :null => false
    t.string  "telefono",           :limit => 20, :default => "", :null => false
    t.string  "cellulare",          :limit => 20, :default => "", :null => false
    t.string  "email",              :limit => 50, :default => "", :null => false
    t.string  "n_brevetto",         :limit => 20, :default => "", :null => false
    t.string  "scadenza_brev",      :limit => 20, :default => ""
    t.string  "tessera_fai",        :limit => 10, :default => "", :null => false
    t.date    "license_expiration"
  end

  create_table "attic_cids", :id => false, :force => true do |t|
    t.string  "filename",     :limit => 40
    t.integer "anno"
    t.integer "cid_pilot_id"
    t.string  "cid_cir",      :limit => 1
    t.integer "id",                         :null => false
  end

  create_table "attic_identities", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "person_id"
    t.string   "fqdn",           :limit => 128,                    :null => false
    t.string   "password",       :limit => 32
    t.boolean  "email_verified"
    t.string   "uuid",           :limit => 22,                     :null => false
    t.boolean  "is_admin",                      :default => false, :null => false
    t.boolean  "privacy",                       :default => true,  :null => false
  end

  add_index "attic_identities", ["fqdn"], :name => "index_identities_on_fqdn", :unique => true
  add_index "attic_identities", ["person_id"], :name => "index_identities_on_person_id"
  add_index "attic_identities", ["uuid"], :name => "index_identities_on_uuid", :unique => true

  create_table "attic_locations", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "address"
    t.text     "city"
    t.string   "zip",               :limit => 10
    t.text     "state"
    t.string   "country",           :limit => 2
    t.float    "lat"
    t.float    "lon"
    t.string   "geocoder",          :limit => 16
    t.string   "geocode_precision", :limit => 16
  end

  create_table "attic_people", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "first_name",          :limit => 64, :null => false
    t.string   "middle_name",         :limit => 64
    t.string   "last_name",           :limit => 64, :null => false
    t.string   "nickname",            :limit => 32
    t.string   "gender",              :limit => 1
    t.date     "birth_date"
    t.string   "vat_number",          :limit => 16
    t.string   "italian_fiscal_code", :limit => 16
    t.text     "notes"
    t.integer  "home_location_id"
    t.integer  "birth_location_id"
    t.string   "tmp_cellulare",       :limit => 32
    t.string   "tmp_telefono",        :limit => 32
    t.boolean  "is_admin"
    t.integer  "fb_uid",              :limit => 8
  end

  create_table "championship_flights", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "championship_id"
    t.integer  "flight_id"
    t.string   "sti_type"
    t.string   "status",          :limit => 8
    t.text     "data"
    t.integer  "distance"
    t.float    "speed"
    t.string   "cid_ranking",     :limit => 32
    t.string   "cid_task_type",   :limit => 32
    t.string   "cid_task_eval",   :limit => 32
  end

  add_index "championship_flights", ["championship_id", "flight_id"], :name => "index_championship_flights_on_championship_id_and_flight_id", :unique => true
  add_index "championship_flights", ["championship_id"], :name => "index_championship_flights_on_championship_id"
  add_index "championship_flights", ["flight_id"], :name => "index_championship_flights_on_flight_id"

  create_table "championship_pilots", :force => true do |t|
    t.integer "championship_id"
    t.integer "pilot_id"
    t.string  "csvva_pilot_level", :limit => 16
    t.string  "cid_category",      :limit => 32
    t.string  "sti_type"
    t.integer "old_pilot_id"
  end

  add_index "championship_pilots", ["championship_id", "pilot_id"], :name => "index_championship_pilots_on_championship_id_and_pilot_id", :unique => true
  add_index "championship_pilots", ["championship_id"], :name => "index_championship_pilots_on_championship_id"
  add_index "championship_pilots", ["pilot_id"], :name => "index_championship_pilots_on_pilot_id"

  create_table "championships", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "name"
    t.text     "icon"
    t.datetime "valid_from"
    t.datetime "valid_to"
    t.string   "driver",     :limit => 16
    t.string   "symbol",     :limit => 32
    t.string   "uuid",       :limit => 36
  end

  add_index "championships", ["symbol"], :name => "index_championships_on_symbol", :unique => true

  create_table "clubs", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "old_club_id"
    t.string   "symbol",      :limit => 32
    t.string   "uuid",        :limit => 36
  end

  add_index "clubs", ["symbol"], :name => "clubs_symbol", :unique => true

  create_table "core_acl_entries", :force => true do |t|
    t.integer "group_id"
    t.integer "identity_id"
    t.integer "obj_id",                    :null => false
    t.string  "obj_type",                  :null => false
    t.string  "capability",  :limit => 32, :null => false
  end

  add_index "core_acl_entries", ["group_id"], :name => "index_core_acl_entries_on_group_id"
  add_index "core_acl_entries", ["identity_id"], :name => "index_core_acl_entries_on_identity_id"
  add_index "core_acl_entries", ["obj_id", "obj_type"], :name => "index_core_acl_entries_on_obj_id_and_obj_type"

  create_table "core_capabilities", :force => true do |t|
    t.string "name",  :limit => 32, :null => false
    t.string "descr"
  end

  add_index "core_capabilities", ["name"], :name => "index_core_capabilities_on_name"

  create_table "core_channels", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "owner_id"
    t.string   "owner_type",   :limit => 127
    t.string   "channel_type"
    t.string   "value"
    t.text     "descr"
    t.integer  "preference",                  :default => 5
  end

  add_index "core_channels", ["owner_type", "owner_id", "channel_type", "value"], :name => "channel_index", :unique => true

  create_table "core_contact_areas", :force => true do |t|
    t.string  "name",      :limit => 32
    t.text    "descr"
    t.integer "parent_id"
  end

  create_table "core_contact_roles", :force => true do |t|
    t.string  "name",      :limit => 32
    t.text    "descr"
    t.integer "parent_id"
  end

  create_table "core_contacts", :force => true do |t|
    t.integer  "identity_id"
    t.integer  "owner_id"
    t.string   "owner_type"
    t.integer  "contact_area_id"
    t.integer  "contact_role_id"
    t.text     "notes"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "core_credentials", :force => true do |t|
    t.integer  "identity_id",                   :null => false
    t.string   "sti_type",        :limit => 64, :null => false
    t.text     "descr"
    t.text     "data",                          :null => false
    t.string   "x509_m_serial",   :limit => 32
    t.string   "x509_i_dn"
    t.string   "x509_s_dn"
    t.string   "x509_s_dn_cn"
    t.string   "x509_s_dn_email"
    t.datetime "expires_at"
  end

  add_index "core_credentials", ["identity_id", "sti_type"], :name => "index_core_credentials_on_identity_id_and_sti_type"
  add_index "core_credentials", ["identity_id"], :name => "index_core_credentials_on_identity_id"
  add_index "core_credentials", ["x509_i_dn", "x509_m_serial"], :name => "index_core_credentials_on_x509_i_dn_and_x509_m_serial", :unique => true
  add_index "core_credentials", ["x509_i_dn"], :name => "index_core_credentials_on_x509_i_dn"

  create_table "core_group_members", :force => true do |t|
    t.integer "group_id"
    t.integer "identity_id"
  end

  create_table "core_groups", :force => true do |t|
    t.string   "uuid",        :limit => 36, :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "name"
    t.text     "description"
  end

  create_table "core_http_sessions", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "remote_addr",        :limit => 42
    t.integer  "remote_port"
    t.text     "x_forwarded_for"
    t.text     "via"
    t.string   "server_addr",        :limit => 42
    t.integer  "server_port"
    t.string   "server_name",        :limit => 64
    t.text     "referer"
    t.text     "user_agent"
    t.text     "request_uri"
    t.integer  "auth_credential_id"
    t.integer  "auth_identity_id"
    t.string   "auth_method",        :limit => 32
    t.string   "auth_confidence",    :limit => 16
    t.string   "close_reason",       :limit => 32
    t.datetime "close_time"
    t.string   "uuid",               :limit => 36,                    :null => false
    t.string   "status",             :limit => 32, :default => "new", :null => false
  end

  add_index "core_http_sessions", ["updated_at"], :name => "index_core_http_sessions_on_updated_at"
  add_index "core_http_sessions", ["uuid"], :name => "index_core_http_sessions_on_uuid"

  create_table "core_identities", :force => true do |t|
    t.integer "person_id"
    t.string  "qualified",  :limit => 128, :null => false
    t.string  "confidence", :limit => 20
    t.boolean "is_admin",                  :null => false
    t.string  "uuid",       :limit => 36
  end

  add_index "core_identities", ["person_id"], :name => "index_core_identities_on_person_id"
  add_index "core_identities", ["qualified"], :name => "index_core_identities_on_qualified", :unique => true

  create_table "core_identity_capabilities", :force => true do |t|
    t.integer "identity_id"
    t.integer "capability_id"
  end

  add_index "core_identity_capabilities", ["capability_id"], :name => "index_core_identity_capabilities_on_capability_id"
  add_index "core_identity_capabilities", ["identity_id"], :name => "index_core_identity_capabilities_on_identity_id"

  create_table "core_locations", :force => true do |t|
    t.integer "locatable_id"
    t.string  "locatable_type", :limit => 127
    t.string  "role",           :limit => 32
    t.text    "street_address"
    t.string  "city",           :limit => 64
    t.string  "state",          :limit => 64
    t.string  "country_code",   :limit => 2
    t.string  "zip",            :limit => 12
    t.float   "lat"
    t.float   "lng"
    t.string  "provider",       :limit => 16
    t.integer "accuracy"
    t.string  "location_type",  :limit => 32
    t.string  "region",         :limit => 128
  end

  create_table "core_log_entries", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "timestamp",                      :null => false
    t.string   "transaction_uuid", :limit => 36
    t.integer  "identity_id"
    t.text     "description",                    :null => false
    t.text     "notes"
    t.text     "extra_info"
    t.integer  "http_session_id"
  end

  add_index "core_log_entries", ["identity_id"], :name => "index_core_log_entries_on_identity_id"
  add_index "core_log_entries", ["timestamp"], :name => "index_core_log_entries_on_timestamp"

  create_table "core_log_entry_details", :force => true do |t|
    t.integer "log_entry_id"
    t.string  "operation",    :limit => 32
    t.integer "obj_id"
    t.string  "obj_type"
    t.string  "obj_uuid",     :limit => 36
    t.text    "obj_key"
    t.text    "obj_snapshot"
  end

  add_index "core_log_entry_details", ["log_entry_id"], :name => "index_core_log_entry_details_on_log_entry_id"
  add_index "core_log_entry_details", ["obj_id", "obj_type"], :name => "index_core_log_entry_details_on_obj_id_and_obj_type"

  create_table "core_organizations", :force => true do |t|
    t.string   "uuid",                          :limit => 36, :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "type",                          :limit => 3
    t.string   "name"
    t.integer  "headquarters_location_id"
    t.integer  "registered_office_location_id"
    t.integer  "invoicing_location_id"
    t.string   "vat_number",                    :limit => 16
    t.string   "italian_fiscal_code",           :limit => 16
    t.text     "notes"
    t.string   "handle",                        :limit => 16, :null => false
    t.integer  "reseller_id"
    t.integer  "admin_group_id"
  end

  create_table "core_people", :force => true do |t|
    t.string   "uuid",                       :limit => 36, :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "title",                      :limit => 16
    t.string   "first_name",                 :limit => 64, :null => false
    t.string   "middle_name",                :limit => 64
    t.string   "last_name",                  :limit => 64, :null => false
    t.string   "nickname",                   :limit => 32
    t.string   "gender",                     :limit => 1
    t.integer  "residence_location_id"
    t.datetime "birth_date"
    t.integer  "birth_location_id"
    t.string   "document_type"
    t.string   "document_number"
    t.integer  "invoicing_location_id"
    t.string   "vat_number",                 :limit => 16
    t.string   "italian_fiscal_code",        :limit => 16
    t.text     "notes"
    t.string   "tmp_telefono",               :limit => 32
    t.string   "tmp_cellulare",              :limit => 32
    t.boolean  "is_admin"
    t.integer  "fb_uid"
    t.string   "handle",                     :limit => 16, :null => false
    t.integer  "reseller_id"
    t.integer  "club_id"
    t.string   "fai_card",                   :limit => 32
    t.string   "gliding_license",            :limit => 32
    t.datetime "gliding_license_expiration"
    t.string   "sti_type",                   :limit => 64
  end

  create_table "core_tasks", :force => true do |t|
    t.string   "uuid",                :limit => 36, :null => false
    t.datetime "created_at"
    t.datetime "expected_completion"
    t.datetime "completed_at"
    t.string   "status",              :limit => 32
    t.string   "description"
    t.integer  "obj_id"
    t.string   "obj_type"
    t.integer  "depends_on_id"
    t.string   "subsystem",           :limit => 32
    t.string   "node",                :limit => 64
    t.string   "operation",           :limit => 32
    t.text     "request_data"
    t.text     "result_data"
    t.text     "log"
    t.integer  "precent"
    t.float    "percent"
  end

  add_index "core_tasks", ["obj_type", "obj_id"], :name => "index_core_provisioning_requests_on_obj_type_and_obj_id"
  add_index "core_tasks", ["uuid"], :name => "index_core_provisioning_requests_on_uuid", :unique => true

  create_table "flight_photos", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "flight_id",                :null => false
    t.integer  "farm_id",                  :null => false
    t.integer  "server_id",                :null => false
    t.string   "photo_id",   :limit => 32, :null => false
    t.string   "secret",     :limit => 32, :null => false
    t.float    "lat"
    t.float    "lon"
    t.text     "url"
    t.text     "caption"
  end

  create_table "flight_tags", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "tag_id",                   :null => false
    t.integer  "flight_id",                :null => false
    t.string   "status",     :limit => 8
    t.text     "data"
    t.string   "sti_type",   :limit => 64
    t.integer  "distance"
    t.integer  "speed"
  end

  add_index "flight_tags", ["flight_id"], :name => "index_flight_tags_on_flight_id"
  add_index "flight_tags", ["tag_id", "flight_id"], :name => "index_flight_tags_on_tag_id_and_flight_id", :unique => true
  add_index "flight_tags", ["tag_id"], :name => "index_flight_tags_on_tag_id"

  create_table "flights", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "pilot_id",                                  :null => false
    t.integer  "plane_id"
    t.integer  "plane_type_configuration_id"
    t.datetime "takeoff_time",                              :null => false
    t.datetime "landing_time",                              :null => false
    t.float    "distance"
    t.integer  "passenger_id"
    t.boolean  "private",                                   :null => false
    t.date     "logger_date"
    t.string   "passenger_name",              :limit => 64
    t.string   "igc_fr_serial",               :limit => 3
    t.integer  "igc_fr_fotd"
    t.string   "igc_fr_manuf",                :limit => 3
    t.float    "speed"
    t.text     "notes_public"
    t.text     "notes_private"
    t.string   "uuid",                        :limit => 36
    t.integer  "old_pilot_id"
  end

  add_index "flights", ["takeoff_time"], :name => "flights_takeoff_time"

  create_table "glider_classes", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "uuid",       :limit => 36
  end

  create_table "igc_tmp_files", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "original_filename", :limit => 64
    t.integer  "pilot_id"
    t.integer  "club_id"
    t.integer  "old_pilot_id"
  end

  create_table "images", :force => true do |t|
    t.string   "image_mime_type"
    t.string   "image_name"
    t.integer  "image_size"
    t.integer  "image_width"
    t.integer  "image_height"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "image_uid"
    t.string   "image_ext"
  end

  create_table "page_part_translations", :force => true do |t|
    t.integer  "page_part_id"
    t.string   "locale"
    t.text     "body"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "page_part_translations", ["page_part_id"], :name => "index_page_part_translations_on_page_part_id"

  create_table "page_parts", :force => true do |t|
    t.integer  "page_id"
    t.string   "title"
    t.text     "body"
    t.integer  "position"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "page_parts", ["id"], :name => "index_page_parts_on_id"
  add_index "page_parts", ["page_id"], :name => "index_page_parts_on_page_id"

  create_table "page_translations", :force => true do |t|
    t.integer  "page_id"
    t.string   "locale"
    t.string   "title"
    t.string   "meta_keywords"
    t.text     "meta_description"
    t.string   "browser_title"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "page_translations", ["page_id"], :name => "index_page_translations_on_page_id"

  create_table "pages", :force => true do |t|
    t.string   "title"
    t.integer  "parent_id"
    t.integer  "position"
    t.string   "path"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "meta_keywords"
    t.text     "meta_description"
    t.boolean  "show_in_menu",        :default => true
    t.string   "link_url"
    t.string   "menu_match"
    t.boolean  "deletable",           :default => true
    t.string   "custom_title"
    t.string   "custom_title_type",   :default => "none"
    t.boolean  "draft",               :default => false
    t.string   "browser_title"
    t.boolean  "skip_to_first_child", :default => false
    t.integer  "lft"
    t.integer  "rgt"
    t.integer  "depth"
  end

  add_index "pages", ["depth"], :name => "index_pages_on_depth"
  add_index "pages", ["id"], :name => "index_pages_on_id"
  add_index "pages", ["lft"], :name => "index_pages_on_lft"
  add_index "pages", ["parent_id"], :name => "index_pages_on_parent_id"
  add_index "pages", ["rgt"], :name => "index_pages_on_rgt"

  create_table "pilot_planes", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "pilot_id"
    t.integer  "plane_id"
    t.integer  "old_pilot_id"
  end

  create_table "pilots", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "person_id",                                :null => false
    t.integer  "club_id"
    t.string   "fai_card",                   :limit => 10
    t.string   "gliding_license",            :limit => 20
    t.integer  "old_pilot_id"
    t.string   "gliding_license_expiration", :limit => 20
    t.string   "uuid",                       :limit => 36
  end

  create_table "plane_type_configurations", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "name",          :limit => 32, :null => false
    t.integer  "plane_type_id",               :null => false
    t.float    "handicap",                    :null => false
    t.float    "club_handicap"
  end

  create_table "plane_types", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "manufacturer",  :limit => 64, :null => false
    t.string   "name",          :limit => 32, :null => false
    t.integer  "seats"
    t.integer  "motor"
    t.float    "handicap"
    t.string   "link_wp"
    t.float    "club_handicap"
  end

  create_table "planes", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "registration",  :limit => 8,  :null => false
    t.integer  "plane_type_id",               :null => false
    t.string   "uuid",          :limit => 36
  end

  create_table "ranking_club_standing_history_entries", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "club_standing_id", :null => false
    t.datetime "snapshot_time"
    t.integer  "position"
    t.float    "value"
    t.text     "data"
  end

  add_index "ranking_club_standing_history_entries", ["club_standing_id"], :name => "index_ranking_club_standing_history_entries_on_standing_id"

  create_table "ranking_club_standings", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "ranking_id", :null => false
    t.integer  "club_id",    :null => false
    t.integer  "position"
    t.float    "value"
    t.text     "data"
  end

  add_index "ranking_club_standings", ["club_id"], :name => "index_ranking_club_standings_on_club_id"
  add_index "ranking_club_standings", ["ranking_id", "club_id"], :name => "index_ranking_club_standings_on_ranking_id_and_club_id", :unique => true
  add_index "ranking_club_standings", ["ranking_id"], :name => "index_ranking_club_standings_on_ranking_id"

  create_table "ranking_flights", :force => true do |t|
    t.integer "ranking_id"
    t.integer "flight_id"
    t.string  "status",     :limit => 8
  end

  add_index "ranking_flights", ["flight_id"], :name => "index_ranking_flights_on_flight_id"
  add_index "ranking_flights", ["ranking_id", "flight_id"], :name => "index_ranking_flights_on_ranking_id_and_flight_id", :unique => true
  add_index "ranking_flights", ["ranking_id"], :name => "index_ranking_flights_on_ranking_id"

  create_table "ranking_groups", :force => true do |t|
    t.string "name"
  end

  create_table "ranking_standing_history_entries", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "standing_id",   :null => false
    t.datetime "snapshot_time"
    t.integer  "position"
    t.float    "value"
    t.text     "data"
  end

  add_index "ranking_standing_history_entries", ["standing_id"], :name => "index_ranking_history_entries_on_ranking_standing_id"

  create_table "ranking_standings", :force => true do |t|
    t.integer  "ranking_id"
    t.integer  "pilot_id"
    t.integer  "position"
    t.float    "value"
    t.text     "data"
    t.integer  "flight_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "old_pilot_id"
  end

  add_index "ranking_standings", ["flight_id"], :name => "index_ranking_standings_on_flight_id"
  add_index "ranking_standings", ["pilot_id"], :name => "index_ranking_standings_on_pilot_id"
  add_index "ranking_standings", ["ranking_id", "pilot_id"], :name => "index_ranking_standings_on_ranking_id_and_pilot_id", :unique => true
  add_index "ranking_standings", ["ranking_id"], :name => "index_ranking_standings_on_ranking_id"

  create_table "ranking_standings2", :id => false, :force => true do |t|
    t.integer "ranking_id"
    t.integer "pilot_id"
    t.integer "position"
    t.float   "value"
    t.text    "data"
    t.integer "id"
    t.integer "flight_id"
  end

  create_table "rankings", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "name"
    t.boolean  "official"
    t.integer  "priority"
    t.string   "color",           :limit => 6
    t.string   "driver",          :limit => 16
    t.datetime "generated_at",                  :null => false
    t.integer  "group_id"
    t.string   "symbol",          :limit => 32
    t.integer  "championship_id"
    t.text     "icon"
    t.string   "uuid",            :limit => 36
    t.string   "sti_type",        :limit => 63
  end

  create_table "refinery_settings", :force => true do |t|
    t.string   "name"
    t.text     "value"
    t.boolean  "destroyable",             :default => true
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "scoping"
    t.boolean  "restricted",              :default => false
    t.string   "callback_proc_as_string"
    t.string   "form_value_type"
  end

  add_index "refinery_settings", ["name"], :name => "index_refinery_settings_on_name"

  create_table "resources", :force => true do |t|
    t.string   "file_mime_type"
    t.string   "file_name"
    t.integer  "file_size"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "file_uid"
    t.string   "file_ext"
  end

  create_table "roles", :force => true do |t|
    t.string "title"
  end

  create_table "roles_users", :id => false, :force => true do |t|
    t.integer "user_id"
    t.integer "role_id"
  end

  add_index "roles_users", ["role_id", "user_id"], :name => "index_roles_users_on_role_id_and_user_id"
  add_index "roles_users", ["user_id", "role_id"], :name => "index_roles_users_on_user_id_and_role_id"

  create_table "sessions", :force => true do |t|
    t.string   "session_id", :null => false
    t.text     "data"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "sessions", ["session_id"], :name => "index_sessions_on_session_id"
  add_index "sessions", ["updated_at"], :name => "index_sessions_on_updated_at"

  create_table "slugs", :force => true do |t|
    t.string   "name"
    t.integer  "sluggable_id"
    t.integer  "sequence",                     :default => 1, :null => false
    t.string   "sluggable_type", :limit => 40
    t.string   "scope",          :limit => 40
    t.datetime "created_at"
    t.string   "locale"
  end

  add_index "slugs", ["locale"], :name => "index_slugs_on_locale"
  add_index "slugs", ["name", "sluggable_type", "scope", "sequence"], :name => "index_slugs_on_name_sluggable_type_scope_and_sequence", :unique => true
  add_index "slugs", ["sluggable_id"], :name => "index_slugs_on_sluggable_id"

  create_table "tag_groups", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "name"
  end

  create_table "tags", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "symbol",                     :limit => 32
    t.string   "name"
    t.integer  "group_id"
    t.boolean  "requires_approval"
    t.string   "color",                      :limit => 6
    t.integer  "ranking_id"
    t.text     "icon"
    t.integer  "depends_on_championship_id"
    t.string   "uuid",                       :limit => 36
  end

  add_index "tags", ["symbol"], :name => "index_tags_on_symbol"

  create_table "user_plugins", :force => true do |t|
    t.integer "user_id"
    t.string  "name"
    t.integer "position"
  end

  add_index "user_plugins", ["name"], :name => "index_user_plugins_on_title"
  add_index "user_plugins", ["user_id", "name"], :name => "index_unique_user_plugins", :unique => true

  create_table "users", :force => true do |t|
    t.string   "username",             :null => false
    t.string   "email",                :null => false
    t.string   "encrypted_password",   :null => false
    t.string   "password_salt",        :null => false
    t.string   "persistence_token"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "perishable_token"
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.integer  "sign_in_count"
    t.string   "remember_token"
    t.string   "reset_password_token"
    t.datetime "remember_created_at"
  end

  add_index "users", ["id"], :name => "index_users_on_id"

end
