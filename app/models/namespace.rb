class Namespace < ActiveRecord::Base
  has_many :fields
  MANDATORY_FIELD_NAMESPACE = 'Mandatory Fields'

  validates :name, uniqueness: true

  def all_fields
    fields + mandatory_fields
  end

  def mandatory_fields
    Namespace.find_by_name(MANDATORY_FIELD_NAMESPACE).fields
  end

  def create_table
    transaction do
      connection.create_table(table_name, id: false)
      create_fields

      connection.execute("ALTER TABLE #{table_name} ADD PRIMARY KEY (uuid);")
      connection.add_index(table_name, :location, spatial: true)
    end
  end

  private

  def create_fields
    all_fields.each do |field|
      connection.add_column(table_name, field.name, field.sql_type)
    end
  end
end
