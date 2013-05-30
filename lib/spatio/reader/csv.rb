# encoding: UTF-8
require 'csv'
require 'open-uri'
require 'sanitize'
require 'spatio/reader/base'

module Spatio
  module Reader
    class CSV < Base
      attr_reader :options

      def self.perform parameters
        Spatio::Reader::CSV.new(parameters).perform
      end

      def perform
        @csv = ::CSV.parse(open(@url),
                           col_sep: options[:col_sep],
                           headers: :first_row,
                           encoding: options[:encoding]).each do |row|
                             @items << generate_item(row)
                           end
                           add_ids
      end

      private
      def generate_item entry
        {
          human_readable_location_in: fill_item(entry, @options[:geo_columns]),
          title: fill_item(entry, @options[:title_columns]),
          meta_data: generate_metadata(entry)
        }
      end

      def generate_metadata entry
        return unless options[:meta_data]
        result = {}
        options[:meta_data].each do |key, value|
          result[key] = fill_item(entry, value)
        end
        result
      end

      def fill_item(entry, columns)
        result = ""
        columns.each do |column|
          result << "#{entry[column]} "
        end
        # TODO: move to method
        result = result.strip.force_encoding options[:input_encoding]
        Sanitize.clean result, output_encoding: options[:output_encoding]
      end

    end
  end
end
