class ChangeIdLength < ActiveRecord::Migration
  def up
    namespace = Namespace.find_by_name('Mandatory Fields')
    Field.where(namespace_id: namespace.id).find_by_name('uuid').
      update_attributes(sql_type: 'VARCHAR (40)') if namespace
  end

  def down
    namespace = Namespace.find_by_name('Mandatory Fields')
    Field.where(namespace_id: namespace.id).find_by_name('uuid').
      update_attributes(sql_type: 'VARCHAR (32)') if namespace
  end
end
