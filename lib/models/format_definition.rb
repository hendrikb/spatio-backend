class FormatDefinition < ActiveRecord::Base
  validates_presence_of :name
  validates_presence_of :importer_class
end
