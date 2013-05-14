SPEC_ROOT = File.dirname(__FILE__)

$LOAD_PATH.unshift(File.join(SPEC_ROOT, '..', 'lib'))
$LOAD_PATH.unshift(File.join(SPEC_ROOT, '..', 'lib', 'spatio'))
$LOAD_PATH.unshift SPEC_ROOT

require 'bundler'
Bundler.require :default, :test
require 'rack/test'

Dir.glob(SPEC_ROOT + '/factories/*').each { |f| require f }
VCR.configure do |c|
  c.cassette_library_dir = 'spec/vcr'
  c.hook_into :fakeweb

  c.ignore_localhost = true
  c.configure_rspec_metadata!
end

ActiveRecord::Base.logger = nil
# setup test environment
set :environment, :test
set :run, false
set :raise_errors, true
set :logging, false

RSpec.configure do |config|
  config.include Rack::Test::Methods

  config.treat_symbols_as_metadata_keys_with_true_values = true

  config.before :each do
    DatabaseCleaner[:active_record].clean_with :truncation
  end
end

require 'simplecov'
SimpleCov.start do
  add_filter '/spec\.rb/'
end

require 'spatio'
