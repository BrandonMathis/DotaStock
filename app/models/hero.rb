class Hero < ActiveRecord::Base
  has_many :player_matches, primary_key: :hero_id
  has_many :matches, through: :player_matches

  validates_presence_of :hero_id
end
