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
        entry[:article] = load_link(entry) if parse_articles?
        @items << generate_item(entry)
      end
      add_ids
    end

    private
    def parameters_valid?
      return !@feed_url.nil?
    end

    def generate_item entry
      {
        human_readable_location_in: fill_item(entry, @options[:geo_columns]),
        title: fill_item(entry, @options[:title_columns]),
        meta_data: generate_metadata(entry),
        url: entry.url
      }
    end

    def generate_metadata entry
      return unless @options[:meta_data]
      result = {}
      @options[:meta_data].each do |key, value|
        result[key] = fill_item(entry, value)
      end
      result
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
        ""
      end
    end

    def fill_item entry, keys
      result = ""
      keys.each do |key|
        result << "#{entry[key.to_sym]}"
      end
      result = result.strip.force_encoding @options[:input_encoding]
      Sanitize.clean result, output_encoding: @options[:output_encoding]
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
