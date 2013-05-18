class CreateLocalities < ActiveRecord::Migration
  def up
    create_table :localities do |t|
      t.string :name
      t.geometry :area, :srid => 3785
      t.integer :community_id

      t.timestamps
    end

    change_table :localities do |t|
      t.index :area, :spatial => true
      t.index :name
    end
  end

  def down
    drop_table :localities
  end
end
