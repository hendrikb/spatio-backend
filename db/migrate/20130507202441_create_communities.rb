class CreateCommunities < ActiveRecord::Migration
  def up
    create_table :communities do |t|
      t.string :name
      t.geometry :area, :srid => 3785

      t.timestamps
    end

    change_table :communities do |t|
      t.index :area, :spatial => true
      t.index :name, :unique => true
    end
  end

  def down
    def down
      drop_table :communities
    end
  end
end
