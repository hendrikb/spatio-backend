class CreateRoads < ActiveRecord::Migration
  def up
    create_table :roads do |t|
      t.string :name
    end

    change_table :roads do |t|
      t.index :name, unique: true
    end
  end

  def down
    drop_table :roads
  end
end
