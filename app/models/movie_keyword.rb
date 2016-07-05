# == Schema Information
#
# Table name: movies_keywords
#
#  id         :integer          not null, primary key
#  movie_id   :integer          not null
#  keyword_id :integer          not null
#

class MovieKeyword < ActiveRecord::Base
  belongs_to :movie
  belongs_to :keyword

  def self.table_name
    "movies_keywords"
  end
end
