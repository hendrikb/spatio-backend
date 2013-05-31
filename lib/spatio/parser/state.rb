# encoding: utf-8

module Spatio
  module Parser
    module State
      def self.perform(location_string)
        ::State.where('? ~* name', location_string).map(&:name)
      end
    end
  end
end
