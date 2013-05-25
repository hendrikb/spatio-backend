class CreateFields < ActiveRecord::Migration
  def up
    create_table :fields do |t|
      t.string :name
      t.integer :namespace_id
      t.string :type
    end
  end

  def down
    drop_table :fields
  end
end
