class CreateProjects < ActiveRecord::Migration[5.1]
  def change
    create_table :projects do |t|
      t.string :name
      t.text :description
      t.references :author, foreign_key: {to_table: :users}
      t.string :status
      t.string :api_host
      t.json :properties

      t.timestamps
    end
    add_index :projects, :name
  end
end
