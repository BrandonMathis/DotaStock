class Match < ActiveRecord::Base
  attr_accessible :match_id

  has_many :player_matches
  has_many :players, through: :player_matches

  has_many :hero_matches
  has_many :heros, through: :hero_matches

  validates_uniqueness_of :match_id
end
