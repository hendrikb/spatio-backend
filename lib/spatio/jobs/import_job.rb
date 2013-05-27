# encoding: utf-8
require './lib/spatio'
require 'logger'
require './lib/spatio/reader'
require 'resque'

LOG = Logger.new(STDOUT)

module Spatio
  # TODO do we need a Spatio::Jobs:: module here?
  # could at least supply logging stuff...

  class ImportJob
    @queue = :spatio_importer

    def self.perform(id)
      import_definition = Import.find(id)
      new(import_definition).perform
    end

    def perform
      LOG.info "JOB #{self.to_s}: Perfoming on #{@reader.to_s}"
      importer_parameters = @format_definition.importer_parameters
      importer_parameters.merge!({ url: @import.url })

      entries = @reader.perform(importer_parameters)
      entries.reject! { |e| already_existing(entries).include? e[:id] }
      entries = add_location entries
      save entries
      LOG.info 'Finished importing'
    end

    private
    def initialize import
      Dir.glob("./lib/spatio/reader/*.rb").each { |file| require file }

      LOG.info "JOB #{self.to_s}: Firing up ImportJob ID: #{import.id}"
      @import = import
      @format_definition = @import.format_definition
      @reader = @format_definition.reader_class
      @namespace = Namespace.find_by_name(@import.namespace)
    end

    def save entries
      entries.each do |entry|
        title = entry[:title]
        begin
          Spatio::Persist.perform(@namespace.table_name,
                                  uuid: entry[:id],
                                  title: title,
                                  location: entry[:location],
                                  created_at: DateTime.now)
          LOG.info "Saved #{title}"
        rescue Spatio::NoLocationError
          LOG.warn "Could not find location: #{title}"
        rescue
          # TODO: differentiate between duplicate key and other errors
          LOG.error "Could not save: #{title}"
        end
      end
    end

    def already_existing entries
      namespace = @namespace
      table = Class.new(ActiveRecord::Base) do
        self.table_name = namespace.table_name
      end
      uuids = entries.map { |e| e[:id] }
      @already_existing_entries ||= table.where(uuid: uuids).map(&:uuid)
    end

    def add_location entries
      LOG.info "JOB #{self.to_s}: Enqueing #{entries.count} entries"
      entries.map do |entry|
        entry[:location] = geocode entry[:human_readable_location_in]
        entry
      end
    end

    def geocode location_string
      location_hash = Spatio::Parser.perform(location_string, @import.geo_context)
      Spatio::Geocode.perform(location_hash)
    end
  end
end
