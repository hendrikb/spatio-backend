SPEC_ROOT = File.dirname(__FILE__)

require File.join( SPEC_ROOT, '..', 'app.rb')


$LOAD_PATH.unshift(File.join(SPEC_ROOT, '..', 'lib'))
$LOAD_PATH.unshift(File.join(SPEC_ROOT, '..', 'lib', 'spatio'))
$LOAD_PATH.unshift SPEC_ROOT


require 'rack/test'

# setup test environment
set :environment, :test
set :run, false
set :raise_errors, true
set :logging, false

RSpec.configure do |config|
  config.include Rack::Test::Methods
end

require 'simplecov'
SimpleCov.start do
  add_filter '/spec\.rb/'
end

require 'spatio'
