class CreateStates < ActiveRecord::Migration
  def up
    create_table :states do |t|
      t.string :name
      t.polygon :area, :srid => 3785

      t.timestamps
    end

    change_table :states do |t|
      t.index :area, :spatial => true
    end
  end

  def down
    def down
      drop_table :states
    end
  end
end
