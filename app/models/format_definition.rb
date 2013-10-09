require 'active_support/inflector'

class FormatDefinition < ActiveRecord::Base
  validates_presence_of :name
  validates_presence_of :importer_class
  validates :name, :uniqueness => true
  serialize :importer_parameters, Hash

  validate :importer_parameters_format
  validate :validate_reader_class

  # Returns the Reader class that is referenced in the importer_class field.
  def reader_class
    require './lib/spatio'
    require './lib/spatio/reader'
    Dir.glob('./lib/spatio/reader/*.rb').each { |file| require file }
    "Spatio::Reader::#{importer_class}".constantize
  end

  # validate that the object has a valid Reader class.
  def validate_reader_class
    begin
      reader_class
    rescue
       errors.add(:importer_class,  'not found, see docs for supported classes')
    end
  end

  # validate that the object has valid importer_parameters
  def importer_parameters_format
    errors.add(:importer_parameters, "title_columns can't be blank") unless title_columns
    errors.add(:importer_parameters, "geo_columns can't be blank") unless geo_columns

    unless valid_article_usage?
      errors.add(:importer_parameters, 'cannot use article without parse_article')
    end
  end

  # Returns importer_parameters[:title_columns]
  def title_columns
    importer_parameters[:title_columns]
  end

  # Returns importer_parameters[:geo_columns]
  def geo_columns
    importer_parameters[:geo_columns]
  end

  # Returns importer_parameters[:meta_data]
  def meta_data
    importer_parameters[:meta_data]
  end

  # - Returns true if both objects have no meta_data
  # - Returns true if both objects have the same keys in meta_data
  # - Returns false otherwise
  def compatible?(other_definition)
    return true if meta_data.nil? && other_definition.meta_data.nil?
    return true if meta_data && meta_data.same_keys?(other_definition.meta_data)
    false
  end

  private

  def valid_article_usage?
    unless importer_parameters[:parse_articles]
      return false if article_in_columns?
      return false if  article_in_meta_data?
    end
    true
  end

  def article_in_columns?
    importer_parameters.each do |_, columns|
      return true if (columns.class == Array && columns.include?('article'))
    end
    false
  end

  def article_in_meta_data?
    importer_parameters.each do |key, columns|
      return true if key == :meta_data && columns.values.flatten.include?('article')
    end
    false
  end
end
