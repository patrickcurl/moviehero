class CreateReviews < ActiveRecord::Migration
  def change
    create_table :reviews do |t|

      t.string :author_name
      t.text :content
      t.string :url
      t.integer :movie_id, null: false
      t.integer :user_id
      t.string :tmdb_id
      t.string :imdb_id
      t.timestamps null: false
    end
    add_index :reviews, :tmdb_id
    add_index :reviews, :imdb_id
    add_index :reviews, :movie_id
    add_index :reviews, :user_id
  end
end
