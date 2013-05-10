# encoding: utf-8

require './lib/spatio/sparql_client'
require './lib/models'

def initialize_states
  puts 'Initializing states'
  State.delete_all

  osm_polygons = Class.new(ActiveRecord::Base) do
    self.table_name = 'planet_osm_polygon'
  end

  osm_polygons.where(name: Spatio::SparqlClient.states).group(:name).
    select('name, ST_TRANSFORM(ST_COLLECT(way), 3785) AS area').each do |state|
    State.create(name: state[:name], area: state[:area])
  end
end

initialize_states
