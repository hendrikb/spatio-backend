# encoding: utf-8
require 'digest/sha1'

module Spatio
  module Reader
    class Base

      def initialize parameters = {}
        @options = default_options.merge parameters
        @url = @options[:url]
        @items = []
        raise 'parameters not valid: you forgot to give :url' unless parameters_valid?
      end

      private

      def generate_metadata entry
        return unless @options[:meta_data]
        result = {}
        @options[:meta_data].each do |key, value|
          result[key] = fill_item(entry, value)
        end
        result
      end

      def add_ids
        @items.each do |item|
          item[:id] = digest item.to_s
        end
      end

      def digest string
        Digest::SHA1.hexdigest string
      end

      def parameters_valid?
        return !@url.nil?
      end

      def default_options
        { input_encoding:'utf-8', output_encoding: 'utf-8' }
      end
    end
  end
end
