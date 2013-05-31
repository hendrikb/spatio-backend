# encoding: utf-8

module Spatio
  module Parser
    module City
      def self.perform(location_string)
        ::Community.where("? ~* concat('[[:<:]]', name, '[[:>:]]')", location_string).
          map(&:name)
      end
    end
  end
end
