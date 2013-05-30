# encoding: utf-8
require 'digest/sha1'

module Spatio
  module Reader
    class Base
      def add_ids
        @items.each do |item|
          item[:id] = digest item.to_s
        end
      end

      private
      def digest string
        Digest::SHA1.hexdigest string
      end
    end
  end
end
