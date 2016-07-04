class CreateMoviesGenres < ActiveRecord::Migration
  def change
    create_table :movies_genres do |t|
      t.integer :movie_id, null: false
      t.integer :genre_id, null: false
    end
    add_index :movies_genres, :movie_id
    add_index :movies_genres, :genre_id
  end
end
