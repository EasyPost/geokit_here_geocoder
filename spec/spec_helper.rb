ENV['RAKE_ENV'] = 'test'

$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'geokit_here_geocoder'

require "vcr"

VCR.configure do |config|
  config.cassette_library_dir = "spec/cassettes"
  config.hook_into :webmock

  config.filter_sensitive_data('<HERE_APP_ID>') { ENV['HERE_APP_ID'] }
  config.filter_sensitive_data('<HERE_APP_CODE>') { ENV['HERE_APP_CODE'] }
end
