# encoding: utf-8

module Spatio
  module Geocode
    class OsmData
      attr_reader :locations

      def self.perform(locations)
        new(locations).perform
      end

      def perform
        district = resolve_districts
        return district.area if district && district.area
        city = resolve_cities
        return city.area if city
      end

      private
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

