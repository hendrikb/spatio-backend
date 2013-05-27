# encoding: UTF-8
require 'active_support'
require 'feedzirra'

module Spatio::Reader
  class RSS
    include Spatio::Reader
    DEFAULT_ENCODING = { input_encoding:'utf-8', output_encoding: 'utf-8' }

    def self.perform parameters
      Spatio::Reader::RSS.new(parameters).perform
    end


    def initialize parameters
      @feed_url = parameters[:url]
      @options = DEFAULT_ENCODING.merge parameters
      @items = []
      raise 'parameters not valid: you forgot to give :url' unless parameters_valid?
    end

    def perform
      fetch_feed
      @feed.entries.each do |entry|
        @items << {
          human_readable_location_in: parseable_locations(entry),
          title: begin entry.title rescue nil end,
          url: entry.url,
          meta_data: {
            description: begin entry.description rescue nil end,
          }
        }
      end
      add_ids
    end

    private
    def parameters_valid?
      return !@feed_url.nil?
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
