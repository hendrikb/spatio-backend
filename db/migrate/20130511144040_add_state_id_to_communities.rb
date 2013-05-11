class AddStateIdToCommunities < ActiveRecord::Migration
  def up
    change_table :communities do |t|
      t.integer :state_id
    end
  end

  def down
    change_table :communities do |t|
      t.remove :state_id
    end
  end
end
