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
      new import_definition
    end

    private
    def  initialize import
      Dir.glob("./lib/spatio/reader/*.rb").each { |file| require file }

      LOG.info "JOB #{self.to_s}: Firing up ImportJob ID: #{import.id}"
      @import = import
      @format_definition = @import.format_definition
      @klass = "Spatio::Reader::#{@format_definition.importer_class}".constantize
      perform
    end

    def perform
      LOG.info "JOB #{self.to_s}: Perfoming on #{@klass.to_s}"
      importer_parameters = (eval @format_definition.importer_parameters) || {}
      importer_parameters.merge!({url: @import.url})

      entries = @klass.perform(importer_parameters)
      entries = add_location entries
    end

    def add_location entries
      LOG.info "JOB #{self.to_s}: Enqueing #{entries.count} entries"
      entries.map do |entry|
        entry[:location] = geocode entry[:human_readable_location_in]
        entry
      end
    end

    def geocode location_string
      #set contact here for now, should be in format definition
      location_hash = Spatio::Parser.perform(location_string, 'Berlin')
      Spatio::Geocode.perform(location_hash)
    end
  end
end
