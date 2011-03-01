ActionController::Routing::Routes.draw do |map|
  match "/#{Jammit.package_path}/:package.:extension", :to => 'jammit#package', :as=>'jammit'
end