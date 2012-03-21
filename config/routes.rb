Flarc::Application.routes.draw do
  namespace :flarc do
    aresources :pilots do
      member do
        get :edit
        get :stats_by_plane
      end

      collection do
        get :add_plane
      end
    end

    aresources :flights do
      member do
        get :photos, :tag_photos, :tag_photos_ajax, :show_map
        post :do_tag_photos
      end

      collection do
        match :submit
        get :calendar
        get :new_pilot_changed
        get :new_plane_changed
        get :new_plane_type_changed
        get :autocomplete_plane
      end
    end

    aresources :planes do
      member do
        get :edit
        get :stats_by_pilot
      end
    end

    aresources :clubs do
    end

    aresources :plane_types do
    end

    aresources :igc_tmp_files do
    end

    aresources :rankings do
      member do
        get :history
      end
    end

    aresources :championships do
      member do
        match 'subscribe'
      end
    end

    aresources :alptherm_history_entry

    match 'registration/check_email' => 'registration#check_email'
    match 'registration/recover_password' => 'registration#recover_password'
    match 'registration' => 'registration#wizard', :as => :registration

    match 'user' => 'user#show', :as => :user

    namespace :csvva do
      get 'flights/autocomplete_passenger' => 'flights#autocomplete_passenger', :as => :autocomplete_passenger
    end

    namespace :cid do
    end

    match 'flickr/:action' => 'flickr'

    match 'fb(/:action)' => 'fb', :defaults => { :action => 'index' }

    match 'static/*path' => 'static#show', :as => :static
  end

  root :to => 'flarc/static#index'
end
