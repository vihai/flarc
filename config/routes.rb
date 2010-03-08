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
      get :edit, :photos, :tag_photos, :tag_photos_ajax, :show_map
      post :do_tag_photos
    end

    collection do
      get :calendar, :new_pilot_changed, :new_plane_changed, :autocomplete_passenger, :autocomplete_plane
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

  match 'session/login' => 'session#show_login_form', :conditions => { :method => :get }
  match 'session/login' => 'session#authenticate', :conditions => { :method => :post }
  match 'session/logout' => 'session#logout', :conditions => { :method => :post }

  match 'registration' => 'registration#show_form', :conditions => { :method => :get }, :as => :registration
  match 'registration' => 'registration#register', :conditions => { :method => :post }

  match 'flickr/:action' => 'flickr'
  match 'static/:site/:id' => 'static#show', :as => :static

  root :to => 'static#show', :defaults => { :site => 'jump', :id => 'home', :pippo => 'asdkfhjsdkfhsdkfhsd' }
end
