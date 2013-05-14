# encoding: UTF-8
require 'active_support'
require 'feedzirra'

module Spatio::Reader
    class RSS

      def self.perform parameters = { input_encoding:'utf-8', output_encoding: 'utf-8' }
        Spatio::Reader::RSS.new(parameters)
      end

      private
      def initialize parameters
        @feed_url = parameters[:url]
        @options = parameters
        raise 'parameters not valid: you forgot to give :url' unless parameters_valid?
        perform
      end

      def parameters_valid?
        return !@feed_url.nil?
      end

      def perform
        fetch_feed
        require 'pry'; binding.pry
        @feed.entries.each do |entry|
          @items << {
            human_readable_location_in: parseable_locations(entry),
            meta_data: {
              title: begin entry.title rescue nil end,
              text: fallback_text(entry),
              url: entry.url
            }
          }
        end
        add_ids
      end


      def fallback_text entry
        begin
          return entry.summary
        rescue
          return entry.title unless entry.title.nil?
          nil
        end
      end

      def load_link entry
        require 'net/http'
        require 'sanitize'

        http_response = Net::HTTP.get(URI(entry.url))
        doc = Nokogiri::HTML http_response
        html = doc.css(parse_articles_selector).to_html
        begin
          encoded_html =  html.force_encoding(@options[:input_encoding])
          Sanitize.clean encoded_html, output_encoding: @options[:output_encoding]
        rescue
          fallback_text entry
        end
      end

      def parseable_locations entry
        if parse_articles?
          load_link entry
        else
          fallback_text entry
        end
      end

      def fetch_feed
        #TODO Do not use Feedzirra as it requires ActiveSupport
        @feed ||= Feedzirra::Feed.fetch_and_parse @feed_url
      end

      def parse_articles?
        @options[:parse_articles]
      end

      def parse_articles_selector
        return "body" if @options[:parse_articles_selector].nil?
        @options[:parse_articles_selector]
      end
    end
end
