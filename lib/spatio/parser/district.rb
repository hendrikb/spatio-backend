
# encoding: utf-8
module Spatio
  module Parser
    class District
      attr_reader :location_string, :communities

      def self.perform(location_string, cities)
        new(location_string, cities).perform
      end

      def initialize(location_string, cities)
        @location_string = location_string
        @communities = Community.where(name: cities)
      end

      def perform
        return [] if communities.empty?
        ::District.where(community_id: communities.map(&:id)).
          where("? ~* concat('[[:<:]]', name, '[[:>:]]')", location_string).map(&:name)
      end
    end
  end
end
