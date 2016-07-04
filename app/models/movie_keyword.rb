class MovieKeyword < ActiveRecord::Base
  belongs_to :movie
  belongs_to :keyword

  def self.table_name
    "movies_keywords"
  end
end
