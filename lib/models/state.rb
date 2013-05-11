class State < ActiveRecord::Base
  has_many :communities, foreign_key: :state_id
  set_rgeo_factory_for_column(:area, RGeo::Geographic.simple_mercator_factory.projection_factory)
end
