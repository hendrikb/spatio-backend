# encoding: utf-8
require './lib/spatio'
require 'logger'
require './lib/spatio/reader'
require 'resque'

LOG = Logger.new(STDOUT)

module Spatio
  class ImportJob
    @queue = :spatio_importer


    # Finds an Import with the id.
    # Then creates a new ImportJob instance with it calls perform on it.
    def self.perform(id)
      import_definition = Import.find(id)
      new(import_definition).perform
    end

    # - Reads the entries from the URL in the Import
    # - Creates a new Importer object for each entry and calls perform on it
    def perform
      start_time = Time.now
      LOG.info "JOB #{self.to_s}: Performing on #{@reader.to_s}"
      import_entries
      LOG.info "Finished importing in #{(Time.now - start_time).duration}."
    end

    private

    def initialize(import)
      Dir.glob('./lib/spatio/reader/*.rb').each { |file| require file }

      LOG.info "JOB #{self.to_s}: Firing up ImportJob ID: #{import.id}"
      @import = import
      @format_definition = @import.format_definition
      @reader = @format_definition.reader_class
      @namespace = Namespace.find_by_name(@import.namespace)
    end


    def import_entries
      LOG.info "JOB #{self.to_s}: Enqueuing #{entries.count} new entries"

      entries.each do |entry|
        Spatio::Importer.new(entry, @namespace, @import.geo_context).perform
      end
    end

    def importer_parameters
      @format_definition.importer_parameters.merge({ url: @import.url })
    end

    def entries
      @entries ||= fetch_entries
    end

    def fetch_entries
      entries = @reader.perform(importer_parameters)
      entries.reject { |e| already_existing(entries).include? e[:id] }
    end

    def already_existing(entries)
      namespace = @namespace
      table = Class.new(ActiveRecord::Base) do
        self.table_name = namespace.table_name
      end
      uuids = entries.map { |e| e[:id] }
      @already_existing_entries ||= table.where(uuid: uuids).map(&:uuid)
    end
  end
end
