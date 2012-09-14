Flarc::Application.routes.draw do
  namespace :flarc do
    hel_resources :pilots do
      member do
        get :stats_by_plane
      end

      collection do
        get :add_plane
      end
    end

    hel_resources :flights do
      member do
        get :edit
        post :change_championship_status
      end

      collection do
        match :submit
        match :submit_update
        get :calendar
      end
    end

    hel_resources :planes do
      member do
        get :stats_by_pilot
      end
    end

    hel_resources :clubs do
    end

    hel_resources :plane_types do
    end

    hel_resources :igc_tmp_files do
    end

    hel_resources :rankings do
      member do
        get :history
      end
    end

    hel_resources :championships do
      member do
        match 'subscribe'
      end
    end

    hel_resources :alptherm_history_entry

    match 'registration/check_email' => 'registration#check_email'
    match 'registration/recover_password' => 'registration#recover_password'
    match 'registration' => 'registration#wizard', :as => :registration

    match 'user' => 'user#show', :as => :user

    namespace :csvva do
      get 'flights/autocomplete_passenger' => 'flights#autocomplete_passenger', :as => :autocomplete_passenger
    end

    namespace :cid do
    end

    match 'static/*path' => 'static#show', :as => :static
  end

  root :to => 'flarc/static#index'
end
