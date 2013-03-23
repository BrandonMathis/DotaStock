class Hero < ActiveRecord::Base
  attr_accessible :hero_id, :name

  has_many :player_heros
  has_many :players, through: :player_heros

  has_many :hero_matches
  has_many :matches, through: :hero_matches

  validates_presence_of :hero_id

  def usage(count)
    match_range = Match.order('created_at DESC').limit(count).map(&:id)
  end
end
