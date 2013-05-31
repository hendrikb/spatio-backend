# encoding: UTF-8
require 'csv'
require 'open-uri'
require 'spatio/reader/base'

module Spatio
  module Reader
    class CSV < Base

      def self.perform parameters
        Spatio::Reader::CSV.new(parameters).perform
      end

      private

      def entries
        ::CSV.parse(open(url),
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
