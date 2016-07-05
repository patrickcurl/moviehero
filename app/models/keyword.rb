# == Schema Information
#
# Table name: keywords
#
#  id         :integer          not null, primary key
#  name       :string
#  slug       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Keyword < ActiveRecord::Base
  extend FriendlyId
  friendly_id :slug_candidates, use: :slugged
  # has_many :featured_movies, foreign_key: "movie_id"
  # belongs_to :featured_movie, foreign_key: "movie_id"
  def slug_candidates
    [ :name ]
  end
  
end
