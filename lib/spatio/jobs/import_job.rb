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
      klass = import_definition.importer_class
      klass.perform porter_definition.importer_parameters
    end

    private
  end
end
