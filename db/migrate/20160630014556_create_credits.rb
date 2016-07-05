class CreateCredits < ActiveRecord::Migration
  def change
    create_table :credits, id: false do |t|
      t.string  :id, null: false
      t.integer :movie_id, null: false
      t.integer :person_id, null: false
      t.integer :cast_id
      t.string :department
      t.string :job
      t.string :character
      t.string :name
      t.integer :order
      t.string :profile_path
      t.string :type #cast/crew
      t.string :slug
      t.timestamps null: false
    end
    execute "ALTER TABLE credits ADD PRIMARY KEY (id);"
    add_index :credits, :movie_id
    add_index :credits, :person_id
    add_index :credits, :slug, unique: true
  end
end
