# encoding: utf-8

module Spatio
  module Parser
    module District
      def self.perform(location_string, city)
        community = Community.find_by_name(city)
        return [] unless community
        districts = ::District.where(community_id: community.id)

        districts.select do |district|
          location_string.include?(district.name)
        end.map(&:name)
      end
    end
  end
end
