class Player < ActiveRecord::Base
  attr_accessible :account_id

  has_many :player_heros
  has_many :heros, through: :player_heros
  has_many :player_matches
  has_many :matches, through: :player_matches


  validates_uniqueness_of :account_id
end
