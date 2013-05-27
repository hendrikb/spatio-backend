# encoding: UTF-8
require 'csv'
require 'open-uri'

module Spatio
  module Reader
    class CSV
      include Spatio::Reader
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
        title =  ""
        options[:title_columns].each do |column|
          title << "#{row[column]} "
        end
        {
          human_readable_location_in: fill_item(row, @options[:geo_columns]),
          meta_data: generate_metadata(row)
        }
      end

      def title
      end

      def generate_metadata row
        result = {}
        result[:title] = fill_item(row, @options[:title_columns])
        options[:meta_data].each do |key, value|
          result[key] = fill_item(row, value)
        end
        result
      end

      def fill_item(row, columns)
        "".tap do |result|
          columns.each do |column|
            result << "#{row[column]} "
          end
        end.strip
      end

      def convert_answer_to_bool answer
        answer.upcase == "J"
      end

      def convert_plz plz
        return nil if plz.nil?
        plz.to_i
      end
    end
  end
end
