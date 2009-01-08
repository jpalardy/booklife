
RAILS_GEM_VERSION = '2.2.2' unless defined? RAILS_GEM_VERSION

require File.join(File.dirname(__FILE__), 'boot')

require File.join(File.dirname(__FILE__), 'initializers', 'variables.rb')

Rails::Initializer.run do |config|
  config.frameworks -= [ :active_resource, :action_mailer ]

  config.gem      "amazon-ecs", :lib => "amazon/ecs"
  config.gem      "rbook-isbn", :lib => "rbook/isbn"
  config.gem          "ferret"
  config.gem  "acts_as_ferret"
  config.gem "memcache-client", :lib => "memcache_util"
  config.gem     "ruby-openid", :lib => "openid"

  config.time_zone = 'UTC'

  raise 'enter value for $SESSION_SECRET' unless $SESSION_SECRET # defined in config/initializers/variables.rb
  config.action_controller.session = {
    :session_key => '_booklife_session',
    :secret      => $SESSION_SECRET
  }

  config.active_record.observers = :ownership_observer
end

raise 'enter value for $AMAZON_ACCESS_KEY_ID' unless $AMAZON_ACCESS_KEY_ID # defined in config/initializers/variables.rb
Amazon::Ecs.options = {:aWS_access_key_id => $AMAZON_ACCESS_KEY_ID}

CACHE = MemCache.new(["127.0.0.1:11211"], :namespace => "booklife")

require 'openid/store/filesystem'

