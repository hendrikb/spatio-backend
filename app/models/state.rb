class State < ActiveRecord::Base
  has_many :communities, foreign_key: :state_id
  set_rgeo_factory_for_column(:area, Spatio::GEOFACTORY)
end
