class FormatDefinition < ActiveRecord::Base
  validates_presence_of :name
  validates_presence_of :importer_class

  def klass
    require './lib/spatio'
    require './lib/spatio/reader'
    Dir.glob("./lib/spatio/reader/*.rb").each { |file| require file }
    eval "Spatio::Reader::#{importer_class}"
  end

  def self.valid_namespace? namespace
    return true if FormatDefinition.find_by_name(namespace)
    false
  end
end
