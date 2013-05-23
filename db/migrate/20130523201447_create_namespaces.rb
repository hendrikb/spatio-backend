class CreateNamespaces < ActiveRecord::Migration
  def up
    create_table :namespaces do |t|
      t.string :name
      t.string :table_name
    end
  end

  def down
    drop_table :namespaces
  end
end
