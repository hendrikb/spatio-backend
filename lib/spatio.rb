# encoding: UTF-8

require 'rgeo'
require 'sinatra'
require 'sinatra/activerecord'

$LOAD_PATH.unshift(File.dirname(__FILE__))
require 'spatio/parser'
require 'spatio/reader'
require 'spatio/geocode'
require 'spatio/exceptions'
require 'spatio/persist'

require 'spatio/jobs/import_job'
require 'spatio/importer'

require 'spatio/core_ext/hash'
require 'spatio/core_ext/numeric'


ENV['RACK_ENV'] ||= 'development'


# This is the main Spatio-Backend entry point. All logics for the backend
# derive from this location.
module Spatio
  # Specifies the default RGeo geofactory used.
  GEOFACTORY = ::RGeo::Geographic.simple_mercator_factory.projection_factory

  # Reads a YAML file and fetches the entry for the current RACK_ENV.
  def self.conf(file)
    YAML.load_file('config/' + file).fetch(ENV['RACK_ENV'])
  end

  # Returns or initializes a Redis instance.
  def self.redis
    @redis || Redis.new(conf('redis.yml'))
  end
end

require './config/initializers/geocoder'
ActiveRecord::Base.establish_connection(Spatio.conf('database.yml'))
require './app/models'
