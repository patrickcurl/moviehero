# == Schema Information
#
# Table name: movies_reviews
#
#  id        :integer          not null, primary key
#  movie_id  :integer          not null
#  review_id :integer          not null
#

class MovieReview < ActiveRecord::Base
  belongs_to :movie
  belongs_to :review

  def self.table_name
    "movies_reviews"
  end
end
