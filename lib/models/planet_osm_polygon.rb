class PlanetOsmPolygon < ActiveRecord::Base
  set_table_name 'planet_osm_polygon'
  set_rgeo_factory_for_column(:way, RGeo::Geographic.simple_mercator_factory.projection_factory)
end
