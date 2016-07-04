class CreateKeywords < ActiveRecord::Migration
  def change
    create_table :keywords, id: false do |t|
      t.integer :id, null: false
      t.string :name
      t.string :slug

      t.timestamps null: false
    end
    execute "ALTER TABLE keywords ADD PRIMARY KEY (id);"
    add_index :keywords, :name, unique: true
    add_index :keywords, :slug, unique: true
  end
end
