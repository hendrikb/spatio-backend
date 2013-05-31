
# encoding: utf-8
module Spatio
  module Parser
    module District
      def self.perform(location_string, cities)
        communities = Community.where(name: cities)
        return [] if communities.empty?

        districts = ::District.where(community_id: communities.map(&:id)).
          where('? ~* name', location_string)

        districts.select do |district|
          location_string.match(/\b#{district.name}\b/)
        end.map(&:name)
      end
    end
  end
end
