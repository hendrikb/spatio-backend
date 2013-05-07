class ChangeStatesUseMultipolygon < ActiveRecord::Migration
  def up
    change_column(:states, :area, :geometry)
  end

  def down
    change_column(:states, :area, :polygon)
  end
end
