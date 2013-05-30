# encoding: UTF-8
require 'csv'
require 'open-uri'
require 'sanitize'
require 'spatio/reader/base'

module Spatio
  module Reader
    class CSV < Base
      attr_reader :options
      DEFAULT_OPTIONS = { encoding:'utf-8', col_sep: ';'}

      def self.perform parameters
        Spatio::Reader::CSV.new(parameters).perform
      end

      def initialize parameters = {}
        @options = DEFAULT_OPTIONS.merge parameters
        @url = @options[:url]
      end

      def perform
        @items = []
        @csv = ::CSV.parse(open(@url),
                           col_sep: options[:col_sep],
                           headers: :first_row,
                           encoding: options[:encoding]).each do |row|
                             @items << generate_item(row)
                           end
                           add_ids
      end

      private
      def generate_item row
        {
          human_readable_location_in: fill_item(row, @options[:geo_columns]),
          title: fill_item(row, @options[:title_columns]),
          meta_data: generate_metadata(row)
        }
      end

      def generate_metadata row
        return unless options[:meta_data]
        result = {}
        options[:meta_data].each do |key, value|
          result[key] = fill_item(row, value)
        end
        result
      end

      def fill_item(row, columns)
        result = ""
        columns.each do |column|
          result << "#{row[column]} "
        end
        # TODO: move to method
        result = result.strip.force_encoding options[:encoding]
        Sanitize.clean result, output_encoding: options[:encoding]
      end

    end
  end
end
