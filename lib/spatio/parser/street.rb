# encoding: UTF-8

module Spatio
  module Parser
    class Street
      attr_reader :location_string, :communities

      # Creates a new Street instance and then calls perform on it.
      def self.perform(location_string)
        new(location_string).perform
      end

      # Normalizes various short spellings of street (e.g. str, str. to
      # straße in the location_string
      def initialize(location_string)
        location_string.gsub!('str.', 'straße')
        location_string.gsub!('Str.', 'Straße')
        location_string.gsub!(/str\b/, 'straße')
        location_string.gsub!(/Str\b/, 'Straße')
        @location_string = location_string
      end

      # Returns all names of streets that occur in the location_string.
      # Assigns a higher priorities to streets that have street_numbers
      def perform
        streets_with_numbers + street_names
      end

      private

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
