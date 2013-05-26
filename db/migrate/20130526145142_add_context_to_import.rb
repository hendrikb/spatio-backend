class AddContextToImport < ActiveRecord::Migration
  def change
    add_column :imports, :geo_context, :string, default: nil
  end
end
