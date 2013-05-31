require 'active_support/inflector'

class FormatDefinition < ActiveRecord::Base
  validates_presence_of :name
  validates_presence_of :importer_class
  validates :name, :uniqueness => true
  serialize :importer_parameters, Hash

  validate :importer_parameters_format

  def reader_class
    require './lib/spatio'
    require './lib/spatio/reader'
    Dir.glob("./lib/spatio/reader/*.rb").each { |file| require file }
    "Spatio::Reader::#{importer_class}".constantize
  end

  def importer_parameters_format
    errors.add(:importer_parameters, 'title_columns can not be empty') unless title_columns
  end

  def title_columns
    importer_parameters[:title_columns]
  end
end
