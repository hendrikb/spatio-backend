# encoding: utf-8

require 'active_support/inflector'
require 'spatio/parser/street'
require 'spatio/parser/district'
require 'spatio/parser/city'
require 'spatio/parser/state'

module Spatio
  module Parser
    class Base
      attr_reader :location_string, :context, :result

      # Creates a new Base instance and then calls perform on it.
      def self.perform(location_string, context = '')
        new(location_string, context).perform
      end

      # Parses the location_string and context and returns a Hash with
      # the following keys
      # - states
      # - cities
      # - districts
      # - streets
      def perform
        resolve_context

        parse_location_string

        result
      end

      private
      def initialize(location_string, context)
        @location_string, @context  = location_string, context
        @result = { }
      end

      def resolve_context
        [:states, :cities].each do |parser|
          tmp = constantize(parser).perform(context) if context.present?
          result[parser] = tmp if tmp
        end
      end

      def parse_location_string
        [:states, :cities, :streets].each do |parser|
          next if result.key?(parser)
          result[parser] = constantize(parser).perform(location_string)
        end
        parse_districts
      end

      def parse_districts
        result[:districts] = Spatio::Parser::District.perform(location_string,
                                                              result[:cities])
      end

      def constantize(class_name)
        "Spatio::Parser::#{class_name.to_s.classify}".constantize
      end
    end
  end
end
