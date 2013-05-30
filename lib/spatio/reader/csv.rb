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
        entries.each do |entry|
          @items << generate_item(entry)
        end
        add_ids
      end

      private

      def entries
        ::CSV.parse(open(@url),
                    col_sep: options[:col_sep],
                    headers: :first_row,
                    encoding: options[:encoding])
      end

      def default_options
        super.merge({ col_sep: ';' })
      end
    end
  end
end
