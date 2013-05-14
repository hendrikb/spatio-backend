class AddDescriptionToFormatDefinition < ActiveRecord::Migration
  def change
    add_column :format_definitions, :description, :text
  end
end
