# encoding: UTF-8
require 'spreadsheet'
require 'open-uri'
require 'spatio/reader/base'

module Spatio
  module Reader
    class Excel < Base

      private

      def entries
        spreadsheet.rows.drop(1)
      end

      def spreadsheet
        Spreadsheet.client_encoding = options[:encoding]
        Spreadsheet.open(open(url)).
          worksheet(options[:spreadsheet])
      end

      def default_options
        super.merge({ spreadsheet: 0 })
      end
    end
  end
end
