# encoding: utf-8

module Spatio
  class ImportJob
    @queue = :spatio_importer

    def self.perform(namespace, url)
    end
  end
end
