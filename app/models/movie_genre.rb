class MovieGenre < ActiveRecord::Base
  belongs_to :movie
  belongs_to :genre

  def self.table_name
    "movies_genres"
  end
end
