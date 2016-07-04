# == Schema Information
#
# Table name: genres
#
#  id         :integer          not null
#  name       :string
#  slug       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Genre < ActiveRecord::Base
  extend FriendlyId
  friendly_id :slug_candidates, use: :slugged
  # has_many :featured_movies, foreign_key: "movie_id"
  # belongs_to :featured_movie, foreign_key: "movie_id"
  def slug_candidates
    [ :name ]
  end
  def self.update
    genres = Tmdb::Genre.movie_list
    genres.each do |x|
      @g = Genre.find_or_create_by(id: x.id)
      @g.name = x.name
      @g.slug = nil
      @g.save
    end
  end
end
