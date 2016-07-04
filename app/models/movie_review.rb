class MovieReview < ActiveRecord::Base
  belongs_to :movie
  belongs_to :review

  def self.table_name
    "movies_reviews"
  end
end
