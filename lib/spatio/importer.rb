# encoding: utf-8
require 'logger'

module Spatio
  class Importer
    attr_reader :entry, :namespace, :geo_context

    def initialize(entry, namespace, geo_context)
      @entry, @namespace, @geo_context = entry, namespace, geo_context
    end

    def perform
      add_location
      save
    end

    def save
      title = entry[:title]
      begin
        Spatio::Persist.perform(namespace.table_name, table_row)
        LOG.info "Saved #{title}"
      rescue Spatio::NoLocationError
        LOG.warn "Could not find location: #{title}"
      rescue
        # TODO: differentiate between duplicate key and other errors
        LOG.error "Could not save: #{title}"
      end
    end

    def table_row
      meta_data = entry[:meta_data] || {}
      {
        uuid: entry[:id],
        title: entry[:title],
        location: entry[:location],
        created_at: DateTime.now
      }.merge meta_data
    end

    def add_location
      @entry[:location] = geocode entry[:location_string]
    end

    def geocode location_string
      location_hash = Spatio::Parser.perform(location_string, geo_context)
      Spatio::Geocode.perform(location_hash)
    end
  end
end
