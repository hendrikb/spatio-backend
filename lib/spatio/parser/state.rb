# encoding: utf-8

module Spatio
  module Parser
    module State
      def self.perform(location_string)
        ::State.all.select do |community|
          location_string.include?(community.name)
        end.map(&:name)
      end
    end
  end
end
