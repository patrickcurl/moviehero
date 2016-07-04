class CreateFeaturedMovies < ActiveRecord::Migration
  def change
    create_table :featured_movies, id: false do |t|
      t.integer :id, null: false
      t.boolean :now_playing, default: false
      t.boolean :upcoming, default: false
      t.boolean :popular, default: false
      t.boolean :top_rated, default: false
      t.timestamps null: false
    end
    execute "ALTER TABLE featured_movies ADD PRIMARY KEY (id);"
  end
end
