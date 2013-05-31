# encoding: UTF-8
require 'feedzirra'
require 'net/http'
require 'spatio/reader/base'

module Spatio::Reader
  class RSS < Base

    def self.perform parameters
      Spatio::Reader::RSS.new(parameters).perform
    end

    private

    def entries
      fetch_feed.entries.map do |entry|
        entry['article'] = load_link(entry) if parse_articles?
        entry
      end
    end

    def fetch_feed
      @feed ||= Feedzirra::Feed.fetch_and_parse url
    end

    def load_link entry
      http_response = Net::HTTP.get(URI(entry.url))
      doc = Nokogiri::HTML http_response
      html = doc.css(parse_articles_selector).to_html
      begin
        encode_clean html
      rescue
        ''
      end
    end

    def parse_articles?
      options[:parse_articles]
    end

    def parse_articles_selector
      return 'body' if options[:parse_articles_selector].blank?
      options[:parse_articles_selector]
    end
  end
end
