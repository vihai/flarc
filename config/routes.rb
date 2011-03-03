Csvva::Application.routes.draw do

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
        get :calendar
        get :new_pilot_changed, :new_plane_changed, :autocomplete_passenger, :autocomplete_plane
      end
    end

    aresources :planes do
      member do
        get :edit
        get :stats_by_pilot
      end
    end

    aresources :plane_types do
    end

  end

  aresources :igc_tmp_files

  aresources :rankings do
    member do
      get :history
    end
  end

  aresources :championships

  aresources :alptherm_history_entry

  get  'registration' => 'registration#show', :as => :registration
  post 'registration' => 'registration#register'
  post 'registration/login_and_associate' => 'registration#login_and_associate'

  match 'flickr/:action' => 'flickr'
  match 'static/:id' => 'static#show', :as => :static

  match 'fb(/:action)' => 'fb', :defaults => { :action => 'index' }

  root :to => 'static#show',
       :defaults => { :id => 'home' }
end
