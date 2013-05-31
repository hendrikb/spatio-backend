# encoding: utf-8

module Spatio
  module Parser
    module City
      def self.perform(location_string)
        # TODO: word boundary matching in psql
        ::State.where('? ~* name', location_string).select do |community|
          location_string.match(/\b#{community.name}\b/)
        end.map(&:name)
      end
    end
  end
end
