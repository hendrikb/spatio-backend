
# encoding: utf-8
module Spatio
  module Parser
    module District
      def self.perform(location_string, cities)
        communities = Community.where(name: cities)
        return [] if communities.empty?

        ::District.where(community_id: communities.map(&:id)).
          where("? ~* concat('[[:<:]]', name, '[[:>:]]')", location_string).map(&:name)
      end
    end
  end
end
