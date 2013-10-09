class Import < ActiveRecord::Base
  validates_presence_of :name
  validates_presence_of :url
  validates_presence_of :namespace
  validates_presence_of :format_definition

  validate :compatibility_in_namespace

  belongs_to :format_definition

  # Calls create_namespace if Namespace is not present.
  def setup_namespace
    return if Namespace.find_by_name namespace
    transaction do
      create_namespace
    end
  end

  # Creates a new Namespace and calls create_fields.
  def create_namespace
      ns = Namespace.create(name: namespace, table_name: namespace.parameterize('_').tableize)
      if ns.valid?
        create_fields(ns.id) if format_definition.meta_data
        ns.create_table
      end
  end

  # Creates a new Field for each key in meta_data.
  def create_fields (namespace_id)
    format_definition.meta_data.each do |field_name, _|
      Field.create(name: field_name,
                   namespace_id: namespace_id,
                   sql_type: 'TEXT')
    end
  end

  # Validates that object is compatible to other Imports with the same
  # namespace.
  def compatibility_in_namespace
    Import.where(namespace: namespace).each do |import|
      unless import.format_definition.compatible? format_definition
        errors.add(:namespace, 'FormatDefinitions in namespace must be compatible')
        break
      end
    end
  end
end
