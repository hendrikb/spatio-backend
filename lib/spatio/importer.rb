# encoding: utf-8
require 'logger'

module Spatio
  class Importer
    attr_reader :entry, :namespace, :geo_context

    def initialize(entry, namespace, geo_context = nil, given_coords = nil)
      @entry, @namespace, @geo_context = entry, namespace, geo_context
      if given_coords
        @entry[:location] = Spatio::GEOFACTORY.point(given_coords[:lat],
                                                     given_coords[:lon])
      end
    end

    def perform
      add_location unless @entry[:location]
      save
    end

    private

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

    def meta_data
      entry[:meta_data] || {}
    end
  end
end
