# == Schema Information
#
# Table name: people
#
#  id         :integer          not null, primary key
#  name       :string           not null
#  slug       :string           not null
#  imdb_id    :integer
#  data       :jsonb
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Person < ActiveRecord::Base
	extend FriendlyId
	friendly_id :name_and_id, use: :slugged
	validates_presence_of :name, :slug
	def name_and_id
    "#{name} #{id}"
  end
end
