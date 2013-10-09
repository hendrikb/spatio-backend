require_relative 'parser/base'

module Spatio
  module Parser
    # Creates a new Base instance and then calls perform on it.
    def self.perform(location_string, context = '')
      Spatio::Parser::Base.perform(location_string, context)
    end
  end
end
