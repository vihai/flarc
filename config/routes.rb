R3::Application.routes.draw do

  resources :pilots do
    member do
      get :edit, :stats_plane
    end

    collection do
      get :add_plane
    end
  end

  resources :flights do
    member do
      get :photos, :tag_photos, :tag_photos_ajax, :show_map
      post :do_tag_photos
    end

    collection do
      get :new_pilot_changed, :new_plane_changed, :autocomplete_passenger, :autocomplete_plane
    end
  end

  resources :igc_tmp_files

  resources :rankings do
    member do
      get :history
    end
  end

  resources :championships

  resources :planes do
    member do
      get :edit, :stats_pilot
    end
  end

  resources :plane_types

  resources :alptherm_history_entry

  get 'session/login' => 'session#show_login_form'

  post 'session/login' => 'session#authenticate',
         :as => :session_login

  post 'session/logout' => 'session#logout'

  get 'registration' => 'registration#show_form',
        :as => :registration

  post 'registration' => 'registration#register'

  match 'flickr/:action' => 'flickr'
  match 'static/:site/:id' => 'static#show', :as => :static

  root :to => 'static#show',
       :defaults => { :site => 'jump', :id => 'home' }
end
