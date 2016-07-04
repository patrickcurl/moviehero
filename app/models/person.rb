# == Schema Information
#
# Table name: people
#
#  id            :integer          not null
#  name          :string           not null
#  adult         :boolean
#  image         :string
#  biography     :text
#  full_bio_link :string
#  awards        :text
#  birthday      :date
#  deathday      :date
#  homepage      :string
#  birth_place   :string
#  sex           :string
#  imdb_id       :integer
#  slug          :string           not null
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

class Person < ActiveRecord::Base
end
