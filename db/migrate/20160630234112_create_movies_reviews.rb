class CreateMoviesReviews < ActiveRecord::Migration
  def change

    create_table :movies_reviews do |t|
      t.integer :movie_id, null: false
      t.integer :review_id, null: false
    end

    add_index :movies_reviews, :movie_id
    add_index :movies_reviews, :review_id

  end
end
