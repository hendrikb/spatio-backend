# encoding; utf-8
require 'active_support/core_ext/string/filters'

module Spatio
  module Geocode
    COUNTRY = 'Germany'

    class Street
      attr_reader :streets, :districts, :cities

      def self.perform(locations)
        new(locations).perform
      end

      def perform
        return unless streets
        result = with_district_and_city if districts.present? && cities.present?
        return result if result
        with_city if cities.present?
      end

      private
      def initialize(locations)
        @streets   = locations[:streets]
        @districts = locations[:districts]
        @cities    = locations[:cities]
      end

      def with_district_and_city
        streets.each do |street|
          districts.each do |district|
            cities.each do |city|
              result = geocode(street, district, city)
              return result if result
            end
          end
        end

        nil
      end

      def with_city
        streets.each do |street|
          cities.each do |city|
            result = geocode(street, '', city)
            return result if result
          end
        end

        nil
      end

      def geocode(street, district = nil, city = nil)
        sleep 1
        coordinates = Geocoder.coordinates(location_string(street,district, city))
        lonlat = ::RGeo::Geographic.simple_mercator_factory.point(coordinates.second, coordinates.first) if coordinates
        lonlat.projection if lonlat
      end

      def location_string(street, district = nil, city = nil)
        "#{street} #{district} #{city} #{COUNTRY}".squish
      end
    end
  end
end
