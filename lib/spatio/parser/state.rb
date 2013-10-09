# encoding: utf-8

module Spatio
  module Parser
    module State
      # Returns all names of states that occur in the location_string.
      def self.perform(location_string)
        ::State.where("? LIKE concat('%', name, '%')", location_string).
          map(&:name)
      end
    end
  end
end
