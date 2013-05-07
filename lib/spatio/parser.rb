require_relative 'parser/base'

module Spatio
  module Parser
    def self.perform(location_string)
      return Spatio::Parser::Base.perform(location_string)
    end
  end
end
