# == Schema Information
#
# Table name: credits
#
#  id           :string           not null, primary key
#  movie_id     :integer          not null
#  person_id    :integer          not null
#  cast_id      :integer
#  department   :string
#  job          :string
#  character    :string
#  name         :string
#  order        :integer
#  profile_path :string
#  type         :string
#  slug         :string
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

class Credit < ActiveRecord::Base 
  extend FriendlyId
	friendly_id :generate_slug, use: :slugged
	validates_presence_of :movie_id, :slug 	
  #belongs_to :person, primary_key: :person_id, foreign_key:id
  #belongs_to :movie, primary_key: :movie_id, foreign_key: :movie_id

  def generate_slug
    if (type == "cast") then
    	"#{character} #{movie.title}"
    elsif (type == "crew") then
    	"#{job} #{movie.title}"
  	else
  		"#{id}"
  	end
  end
  def self.truncate!
    connection.execute("truncate table credits")
    connection.reset_pk_sequence!('credits')
  end
end
