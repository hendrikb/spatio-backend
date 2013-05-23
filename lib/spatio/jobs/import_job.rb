# encoding: utf-8
require './lib/spatio'
require 'logger'

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
      require './lib/spatio'
      require './lib/spatio/reader'
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
      enqueue_for_geocoding entries
    end

    def enqueue_for_geocoding entries
      require 'resque'

      LOG.info "JOB #{self.to_s}: Enqueing #{entries.count} entries"
      entries.each do |entry|
        if Resque.enqueue(Spatio::GeoPersistJob, entry)
        else
          raise Error "Could not enque #{entry.to_s}"
        end
      end
    end
  end
end
