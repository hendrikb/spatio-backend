# encoding : utf-8 -*-

module Spatio
  module Parser
    class Street
      attr_reader :location_string, :communities

      def self.perform(location_string)
        ::Road.where("? ~* concat('[[:<:]]', name, '[[:>:]]')", location_string).
          map(&:name)
      end
    end
  end
end
