# encoding: utf-8

module Spatio
  module Geocode
    class OsmData
      attr_reader :locations

      # Creates a new OsmData instance and then calls perform on it.
      def self.perform(locations)
        new(locations).perform
      end

      # - Returns a district polygon if it finds one.
      # - Returns a city polygon if it finds one otherwise.
      def perform
        district = resolve_districts
        return district.area if district && district.area
        city = resolve_cities
        return city.area if city
      end

      private

      # Initialize a new OsmData object with a Hash with the following keys:
      # - streets
      # - districts
      def initialize(locations)
        @locations = locations
      end

      def resolve_districts
        return unless locations[:districts]
        ::District.
          where(community_id: community_ids).
          where(name: locations[:districts]).
          first
      end

      def resolve_cities
        return unless locations[:cities]
        cities.first
      end

      def cities
        cities ||= Community.where(name: locations[:cities])
      end

      def community_ids
        cities.map(&:id)
      end
    end
  end
end

