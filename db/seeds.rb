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
  INSERT INTO COMMUNITIES(name, area, created_at, updated_at, state_id)
  SELECT planet_osm_polygon.name, ST_TRANSFORM(ST_COLLECT(way), 3785), NOW(), NOW(), states.id
  FROM planet_osm_polygon
  INNER JOIN states ON ST_CONTAINS(states.area, ST_TRANSFORM(way, 3785))
  WHERE admin_level = '8'
  AND planet_osm_polygon.name IS NOT NULL
  AND planet_osm_polygon.name <> '?'
  GROUP BY planet_osm_polygon.name, states.id
sql

def initialize_communities
  puts 'Initializing communities'
  Community.delete_all

  ActiveRecord::Base.connection.insert_sql(COMMUNITY_QUERY)

  Spatio::SparqlClient.cities.each do |city|
    ActiveRecord::Base.connection.execute("
      INSERT INTO COMMUNITIES(name, area, created_at, updated_at, state_id)
      SELECT planet_osm_polygon.name, ST_TRANSFORM(ST_COLLECT(way), 3785), NOW(), NOW(), states.id
      FROM planet_osm_polygon
      INNER JOIN states ON ST_CONTAINS(states.area, ST_TRANSFORM(way, 3785))
      WHERE planet_osm_polygon.name= '#{city}'
      GROUP BY planet_osm_polygon.name, states.id")
  end
end

initialize_states
initialize_communities