# encoding: utf-8

module Spatio
  module Parser
    module City
      # Returns all names of communities(cities) that occur in the
      # location_string.
      def self.perform(location_string)
        ::Community.where("? LIKE concat('%', name, '%')", location_string).
          map(&:name)
      end
    end
  end
end
