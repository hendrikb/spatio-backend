class FormatDefinition < ActiveRecord::Base
  attr_accessor :name, :importer_class, :importer_parameters

  validates_presence_of :name
  validates_presence_of :importer_class
end
