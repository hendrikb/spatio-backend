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

COMMUNITY_QUERY = <<-sql
INSERT INTO COMMUNITIES(name, area, created_at, updated_at)
SELECT name, ST_TRANSFORM(ST_COLLECT(way), 3785), NOW(), NOW()
FROM planet_osm_polygon
WHERE admin_level = '8'
AND name IS NOT NULL
AND name <> '?'
GROUP BY name
sql

def initialize_communities
  puts 'Initializing communities'
  Community.delete_all

  ActiveRecord::Base.connection.insert_sql(COMMUNITY_QUERY)

  osm_polygons = Class.new(ActiveRecord::Base) do
    self.table_name = 'planet_osm_polygon'
  end

  osm_polygons.where(name: Spatio::SparqlClient.cities).group(:name).
    select('name, ST_TRANSFORM(ST_COLLECT(way), 3785) AS area').each do |city|
    Community.create(name: city[:name], area: city[:area]) rescue next
  end
end

initialize_states
initialize_communities
