class CreateDistricts < ActiveRecord::Migration
  def up
    create_table :districts do |t|
      t.string :name
      t.geometry :area, :srid => 3785
      t.integer :community_id

      t.timestamps
    end

    change_table :districts do |t|
      t.index :area, :spatial => true
      t.index :name
    end
  end

  def down
    drop_table :districts
  end
end
