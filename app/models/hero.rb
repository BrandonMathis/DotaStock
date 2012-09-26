class Hero < ActiveRecord::Base
  attr_accessible :hero_id, :name
  has_many :players

  validates_presence_of :hero_id
end
