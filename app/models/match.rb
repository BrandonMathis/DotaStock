class Match < ActiveRecord::Base
  attr_accessible :match_id
  has_many :players

  validates_uniqueness_of :match_id
end
