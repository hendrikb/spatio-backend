require 'active_support/inflector'

class FormatDefinition < ActiveRecord::Base
  validates_presence_of :name
  validates_presence_of :importer_class
  validates :name, :uniqueness => true
  serialize :importer_parameters, Hash

  def reader_class
    require './lib/spatio'
    require './lib/spatio/reader'
    Dir.glob("./lib/spatio/reader/*.rb").each { |file| require file }
    "Spatio::Reader::#{importer_class}".constantize
  end

  def create_namespace
    namespace = Namespace.create(name: name, table_name: name.parameterize('_').tableize)
    importer_parameters[:meta_data].each do |field_name, _|
      Field.create(name: field_name,
                   namespace: namespace.id,
                   sql_type: "TEXT")
    end
    namespace.create_table if namespace.valid?
  end
end
