# encoding: utf-8

module Spatio
  module Parser
    module District
      def self.perform(location_string, cities)
        communities = Community.where(name: cities)
        return [] if communities.empty?
        districts = ::District.where(community_id: communities.map(&:id))

        districts.select do |district|
          location_string.include?(district.name)
        end.map(&:name)
      end
    end
  end
end
