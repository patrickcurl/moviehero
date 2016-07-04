class CreatePeople < ActiveRecord::Migration
  def change
    create_table :people, id: false do |t|
      t.integer :id, null: false
      t.string :name, null: false
      t.string :slug, null: false
      t.integer :imdb_id
      t.jsonb :data
      # t.boolean :adult
      # t.string :image
      # t.text :biography
      # t.string :full_bio_link
      # t.text :awards
      # t.date :birthday
      # t.date :deathday
      # t.string :homepage
      # t.string :birth_place
      # t.string :sex
      # t.integer :imdb_id


      t.timestamps null: false
    end
      execute "ALTER TABLE people ADD PRIMARY KEY (id);"
      add_index :people, :slug, unique: true
      add_index :people, :name
      add_index :people, :imdb_id, unique: true
      add_index :people, :data, using: :gin
  end
end
