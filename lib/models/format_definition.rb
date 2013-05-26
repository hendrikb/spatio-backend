require 'active_support/inflector'

class FormatDefinition < ActiveRecord::Base
  validates_presence_of :name
  validates_presence_of :importer_class
  validates :namespace, :uniqueness => true

  def reader_class
    require './lib/spatio'
    require './lib/spatio/reader'
    Dir.glob("./lib/spatio/reader/*.rb").each { |file| require file }
    "Spatio::Reader::#{importer_class}".constantize
  end

  def create_namespace
    # TODO: add fields
    namespace = Namespace.create(name: name, table_name: name.parameterize('_').tableize)
    namespace.create_table if namespace.valid?
  end
end
