# encoding: utf-8
require 'digest/sha1'
require 'sanitize'

module Spatio
  module Reader
    class Base
      attr_reader :options, :items, :url

      def self.inherited subklass
        Spatio::AVAILABLE_READERS << subklass
      end

      def perform
        entries.each do |entry|
          @items << generate_item(entry)
        end
        add_ids
      end

      def initialize parameters = {}
        @options = default_options.merge parameters
        @url = options[:url].strip
        @items = []
        raise 'parameters not valid: you forgot to give :url' unless parameters_valid?
      end

      private

      def generate_item entry
        {
          location_string: fill_item(entry, options[:geo_columns]),
          title: fill_item(entry, options[:title_columns]),
          meta_data: generate_metadata(entry)
        }
      end

      def generate_metadata entry
        return unless @options[:meta_data]
        result = {}
        options[:meta_data].each do |key, value|
          result[key] = fill_item(entry, value)
        end
        result
      end

      def fill_item entry, keys
        result = ''
        keys.each do |key|
          result << "#{entry[key]} "
        end
        encode_clean result
      end

      def add_ids
        items.each do |item|
          item[:id] = digest item.to_s
        end
      end

      def digest string
        Digest::SHA1.hexdigest string
      end

      def parameters_valid?
        return url.present?
      end

      def default_options
        { encoding:'utf-8' }
      end

      def encode_clean string
        result = string.strip.force_encoding options[:encoding]
        result = Sanitize.clean result, output_encoding: options[:encoding]
        result.encode("UTF-8", options[:encoding])
      end
    end
  end
end
