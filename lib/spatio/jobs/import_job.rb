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
      import_entries
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


    def import_entries
      importer_parameters = @format_definition.importer_parameters
      importer_parameters.merge!({ url: @import.url })

      entries = @reader.perform(importer_parameters)
      entries.reject! { |e| already_existing(entries).include? e[:id] }

      LOG.info "JOB #{self.to_s}: Enqueing #{entries.count} new entries"

      entries.each do |entry|
        Spatio::Importer.new(entry, @namespace, @import.geo_context).perform
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
  end
end
