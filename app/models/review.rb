# == Schema Information
#
# Table name: reviews
#
#  id          :integer          not null, primary key
#  author_name :string
#  content     :text
#  url         :string
#  movie_id    :integer          not null
#  user_id     :integer
#  tmdb_id     :string
#  imdb_id     :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class Review < ActiveRecord::Base

  def self.importReviews
    (0..550).each do |x|
    begin
      data = Movie.apiCall("Tmdb::Movie.reviews(#{x})").each_pair{|x,y| {x:y}}
      if data[:total_results] > 1
        print x, ": ", data[:total_results], " results\n"
      end
      if data[:total_pages] > 1
        return data
      end
    rescue
      nil
    end
  end
  end
#   def pagedInsert(data)
#     reviews = []
#     page = 1
#     data.total_pages.each do |page_num|
#     reviews[page_num] = data.map{|x|
#     if !x.blank? then
#
#       Review.where(tmdb_id: x.id, author_name: x.author).first_or_create
#
#     else
#       nil
#     end
#   }.reject{|x| x.nil?}
# end
end
# t.string :author_name
# t.text :content
# t.string :url
# t.integer :movie_id, null: false
# t.integer :user_id
# t.string :tmdb_id
# t.string :imdb_id
# t.timestamps null: false
