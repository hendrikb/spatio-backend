# encoding: UTF-8
require 'feedzirra'
require 'net/http'
require 'spatio/reader/base'

module Spatio::Reader
  class RSS < Base
    def self.perform parameters
      Spatio::Reader::RSS.new(parameters).perform
    end

    def perform
      entries.each do |entry|
        entry['article'] = load_link(entry) if parse_articles?
        @items << generate_item(entry)
      end
      add_ids
    end

    private
    def generate_item entry
      super.merge({ url: entry.url })
    end

    def load_link entry
      http_response = Net::HTTP.get(URI(entry.url))
      doc = Nokogiri::HTML http_response
      html = doc.css(parse_articles_selector).to_html
      begin
        encode_clean html
      rescue
        ""
      end
    end

    def entries
      fetch_feed.entries
    end

    def fetch_feed
      @feed ||= Feedzirra::Feed.fetch_and_parse @url
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
