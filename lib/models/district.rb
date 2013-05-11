class District < ActiveRecord::Base
  belongs_to :community

  set_rgeo_factory_for_column(:area, RGeo::Geographic.simple_mercator_factory.projection_factory)
end