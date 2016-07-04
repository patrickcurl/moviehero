class CreateMovies < ActiveRecord::Migration
  def change
    create_table :movies, id: false do |t|
      t.integer :id, null: false
      t.string :title, null: false
      t.string :slug

      # t.boolean :adult
      # t.string :backdrop_path
      # t.jsonb :belongs_to_collection
      # t.string :budget
      # t.string :homepage
      # t.string :imdb_id
      # t.string :original_language
      # t.string :original_title
      # t.text :overview
      # t.string :title
      # t.date :release_date
      # t.float :popularity
      # t.integer :vote_count
      # t.float :vote_average
      # t.string :poster_path
      #
      t.jsonb :data
      t.jsonb :videos
      t.jsonb :posters
      t.jsonb :backdrops
      t.timestamps null: false
    end
    # add_index :movies, :id, unique: true
    execute "ALTER TABLE movies ADD PRIMARY KEY (id);"
    add_index :movies, :slug, unique: true
    add_index :movies, :data, using: :gin
    add_index :movies, :videos, using: :gin
    add_index :movies, :posters, using: :gin
    add_index :movies, :backdrops, using: :gin
  end
end
