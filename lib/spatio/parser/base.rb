# encoding: utf-8

require 'active_support/inflector'
require 'spatio/parser/street'
require 'spatio/parser/city'

module Spatio
  module Parser
    class Base
      attr_reader :location_string

      def self.perform(location_string)
        new(location_string).perform
      end

      def perform
        result = {}
        [:streets, :cities].each do |parser|
          result[parser] =
            constantize(parser).perform(location_string)
        end
        result
      end

      private
      def initialize(location_string)
        @location_string = location_string
      end

      def constantize(class_name)
        "Spatio::Parser::#{class_name.to_s.classify}".constantize
      end
    end
  end
end
