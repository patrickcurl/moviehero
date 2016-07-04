class CreateGenres < ActiveRecord::Migration
  def change
    create_table :genres, id: false do |t|
      t.integer :id, null: false
      t.string :name
      t.string :slug

      t.timestamps null: false
    end
    execute "ALTER TABLE genres ADD PRIMARY KEY (id);"
    add_index :genres, :name, unique: true
    add_index :genres, :slug, unique: true
  end
end
