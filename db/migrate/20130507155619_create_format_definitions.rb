class CreateFormatDefinitions < ActiveRecord::Migration
  def change
    create_table :format_definitions do |t|
      t.string :name
      t.string :importer_class
      t.text :importer_parameters
    end
    add_index :format_definitions, :name, unique: true
  end
end
