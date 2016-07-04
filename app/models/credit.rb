# == Schema Information
#
# Table name: credits
#
#  id           :string           not null
#  movie_id     :integer
#  person_id    :integer
#  cast_id      :integer
#  credit_type  :string
#  character    :string
#  name         :string
#  order        :integer
#  profile_path :string
#  department   :string
#  job          :string
#  media_type   :string
#  title        :string
#  release_date :date
#  poster_path  :string
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

class Credit < ActiveRecord::Base

  #belongs_to :person, primary_key: :person_id, foreign_key:id
  #belongs_to :movie, primary_key: :movie_id, foreign_key: :movie_id

  def self.truncate!
    connection.execute("truncate table credits")
    connection.reset_pk_sequence!('credits')
  end
end
