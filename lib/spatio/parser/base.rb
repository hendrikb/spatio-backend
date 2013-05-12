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

      def self.perform(location_string, context = '')
        new(location_string, context).perform
      end

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
        parse_states
        parse_cities
        parse_districts
        parse_streets
      end

      def parse_states
        return if result.has_key?(:states)
        result[:states] = Spatio::Parser::State.perform(location_string)
      end

      def parse_cities
        return if result.has_key?(:cities)
        result[:cities] = Spatio::Parser::City.perform(location_string)
      end

      def parse_districts
        result[:districts] = Spatio::Parser::District.perform(location_string, result[:cities])
      end

      def parse_streets
        result[:streets] = Spatio::Parser::Street.perform(location_string)
      end

      def constantize(class_name)
        "Spatio::Parser::#{class_name.to_s.classify}".constantize
      end
    end
  end
end
