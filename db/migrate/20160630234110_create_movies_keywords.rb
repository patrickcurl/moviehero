class CreateMoviesKeywords < ActiveRecord::Migration
  def change

    create_table :movies_keywords do |t|
      t.integer :movie_id, null: false
      t.integer :keyword_id, null: false
    end

    add_index :movies_keywords, :movie_id
    add_index :movies_keywords, :keyword_id

  end
end
