class Locality < ActiveRecord::Base
  belongs_to :community

  set_rgeo_factory_for_column(:area, Spatio::GEOFACTORY)
end
