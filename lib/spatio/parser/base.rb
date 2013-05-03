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

      def initialize(location_string)
        @location_string = location_string
      end

      def perform
        result = {}
        [:street, :city].each do |parser|
          result[parser] =
            "Spatio::Parser::#{parser.to_s.classify}".constantize.perform(location_string)
        end
        result
      end

    end
  end
end
