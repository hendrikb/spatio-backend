class Import < ActiveRecord::Base
  validates_presence_of :name
  validates_presence_of :url
  validates_presence_of :namespace
  validates_presence_of :format_definition

  validate :compatibility_in_namespace

  belongs_to :format_definition

  def create_namespace
    transaction do
      ns = Namespace.create(name: namespace, table_name: namespace.parameterize('_').tableize)
      create_fields if ns.valid? && format_definition.importer_parameters[:meta_data]
      ns.create_table if ns.valid?
    end
  end

  def create_fields
    format_definition.importer_parameters[:meta_data].each do |field_name, _|
      Field.create(name: field_name,
                   namespace: ns.id,
                   sql_type: "TEXT")
    end
  end

  def compatibility_in_namespace
    Import.where(namespace: namespace).each do |import|
      unless import.format_definition.compatible? format_definition
        errors.add(:namespace, 'FormatDefinitions in namespace must be compatible')
        break
      end
    end
  end
end
