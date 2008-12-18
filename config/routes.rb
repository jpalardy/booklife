ActionController::Routing::Routes.draw do |map|
  map.resources :ownerships, :as => 'books', :path_prefix => '/:username'

  map.login   'login', :controller => 'session', :action => 'new',    :conditions => { :method => :get }
  map.connect 'login', :controller => 'session', :action => 'create', :conditions => { :method => :post }
  map.logout 'logout', :controller => 'session', :action => 'destroy'

  map.complete_openid 'login/complete', :controller => 'session', :action => 'complete', :conditions => { :method => :get }

  map.register 'register', :controller => 'users', :action => 'new', :conditions => { :method => :get }
  map.register 'register', :controller => 'users', :action => 'create', :conditions => { :method => :post }

  map.amazon 'amazon', :controller => 'amazon'

  map.root   :controller => 'session', :action => 'new'

  # Install the default routes as the lowest priority.
  # Note: These default routes make all actions in every controller accessible via GET requests. You should
  # consider removing the them or commenting them out if you're using named routes and resources.
  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
end
