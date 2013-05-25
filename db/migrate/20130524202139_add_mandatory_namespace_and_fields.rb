class AddMandatoryNamespaceAndFields < ActiveRecord::Migration
  def up
    namespace = Namespace.create(name: 'Mandatory Fields')
    fields = { uuid: 'VARCHAR (32)',
               title: 'TEXT',
               location: 'GEOMETRY',
               created_at: 'TIMESTAMP' }
    fields.each do |name, data_type|
      Field.create(name: name, namespace: namespace, sql_type: data_type)
    end
  end

  def down
    namespace = Namespace.find_by_name('Mandatory Fields')
    Field.where(namespace_id: namespace.id).delete_all
    namespace.delete
  end
end
