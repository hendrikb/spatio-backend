# encoding: utf-8
require_relative 'geocode/street'
require_relative 'geocode/osm_data'

module Spatio
  module Geocode
    def self.perform(locations)
      result = Spatio::Geocode::Street.perform(locations)
      return result if result.present?
      Spatio::Geocode::OsmData.perform(locations)
    end
  end
end
