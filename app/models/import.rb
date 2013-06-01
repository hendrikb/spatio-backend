class Import < ActiveRecord::Base
  validates_presence_of :name
  validates_presence_of :url
  validates_presence_of :namespace
  validates_presence_of :format_definition

  validate :compatibility_in_namespace

  belongs_to :format_definition

  def create_namespace
    return if Namespace.find_by_name namespace
    transaction do
      ns = Namespace.create(name: namespace, table_name: namespace.parameterize('_').tableize)
      if ns.valid?
        create_fields if format_definition.meta_data
        ns.create_table
      end
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
