$LOAD_PATH.unshift(File.dirname(__FILE__))
require 'spatio/parser'
require 'spatio/reader'
require 'spatio/geocode'
require 'spatio/persist'

require './config/initializers/geocoder'
require 'rgeo'

module Spatio
  GEOFACTORY = ::RGeo::Geographic.simple_mercator_factory.projection_factory
end

require 'models'
