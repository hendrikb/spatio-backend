class RenameTypeToSqlType < ActiveRecord::Migration
  def up
    rename_column :fields, :type, :sql_type
  end

  def down
    rename_column :fields, :sql_type, :type
  end
end
