class Community < ActiveRecord::Base
  belongs_to :state
  has_many :districts

  set_rgeo_factory_for_column(:area, Spatio::GEOFACTORY)
end
