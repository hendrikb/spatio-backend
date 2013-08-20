# encoding : utf-8 -*-

module Spatio
  module Parser
    class Street
      attr_reader :location_string, :communities

      def self.perform(location_string)
        new(location_string).perform
      end

      def initialize(location_string)
        @location_string = location_string
      end

      def perform
        streets_with_numbers + street_names
      end

      def streets_with_numbers
        result = []
        street_names.each do |street|
          match = location_string.match(/#{street} \d+/)
          result << match.to_s if match
        end

        result
      end

      def street_names
        @street_names ||= ::Road.where("? LIKE concat('%', name, '%')", location_string).
          map(&:name)
      end
    end
  end
end
