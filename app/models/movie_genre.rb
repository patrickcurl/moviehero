# == Schema Information
#
# Table name: movies_genres
#
#  id       :integer          not null, primary key
#  movie_id :integer          not null
#  genre_id :integer          not null
#

class MovieGenre < ActiveRecord::Base
  belongs_to :movie
  belongs_to :genre

  def self.table_name
    "movies_genres"
  end
end
