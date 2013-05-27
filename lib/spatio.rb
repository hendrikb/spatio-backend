require './config/initializers/geocoder'
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


ENV['RACK_ENV'] ||= 'development'

def conf(file)
  YAML.load_file('config/' + file).fetch(ENV['RACK_ENV'])
end

module Spatio
  GEOFACTORY = ::RGeo::Geographic.simple_mercator_factory.projection_factory

  def self.redis
    @redis || Redis.new(conf('redis.yml'))
  end
end

ActiveRecord::Base.establish_connection conf('database.yml')
require 'models'
