class CreateImport < ActiveRecord::Migration
  def change
    create_table :imports do |t|
      t.string :name
      t.string :url
      t.string :namespace
      t.integer :format_definition_id
      t.text :description
    end

  end
end
