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
    errors.add(:importer_parameters, 'geo_columns can not be empty') unless geo_columns

    unless valid_article_usage?
      errors.add(:importer_parameters, 'cannot use article without parse_article')
    end
  end

  def title_columns
    importer_parameters[:title_columns]
  end

  def geo_columns
    importer_parameters[:geo_columns]
  end

  def meta_data
    importer_parameters[:meta_data]
  end

  def compatible? other_definition
    return true unless meta_data
    return true if meta_data.same_keys?(other_definition.meta_data)
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
