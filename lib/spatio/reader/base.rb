# encoding: utf-8
require 'digest/sha1'

module Spatio
  module Reader
    class Base
      DEFAULT_OPTIONS = { col_sep: ';',
                          input_encoding:'utf-8',
                          output_encoding: 'utf-8' }

      def initialize parameters = {}
        @options = DEFAULT_OPTIONS.merge parameters
        @url = @options[:url]
        @items = []
      end

      private
      def add_ids
        @items.each do |item|
          item[:id] = digest item.to_s
        end
      end

      def digest string
        Digest::SHA1.hexdigest string
      end
    end
  end
end
