# encoding: utf-8

module Spatio
  module Parser
    module City
      def self.perform(location_string)
        Community.all.select do |community|
          location_string.include?(community.name)
        end.map(&:name)
      end
    end
  end
end
