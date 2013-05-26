require 'active_support/inflector'

class FormatDefinition < ActiveRecord::Base
  validates_presence_of :name
  validates_presence_of :importer_class

  def reader_class
    require './lib/spatio'
    require './lib/spatio/reader'
    Dir.glob("./lib/spatio/reader/*.rb").each { |file| require file }
    "Spatio::Reader::#{importer_class}".constantize
  end

  def self.valid_namespace? namespace
    return true if FormatDefinition.find_by_name(namespace)
    false
  end

  def create_namespace
    # TODO: add fields
    namespace = Namespace.create(name: name, table_name: name.parameterize('_').tableize)
    namespace.create_table if namespace.valid?
  end
end
