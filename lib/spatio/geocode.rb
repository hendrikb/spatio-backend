# encoding: utf-8
require_relative 'geocode/street'
require_relative 'geocode/osm_data'

module Spatio
  module Geocode
    # Sets the default country scope for geocoding.
    COUNTRY = 'Germany'

    # Calls Street.perform and returns it if present
    # Falls back on OsmData.perform otherwise
    def self.perform(locations)
      result = Spatio::Geocode::Street.perform(locations)
      return result if result.present?
      Spatio::Geocode::OsmData.perform(locations)
    end
  end
end
