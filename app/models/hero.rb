class Hero < ActiveRecord::Base
  attr_accessible :hero_id, :name
  has_many :players
  has_many :matches, through: :players

  validates_presence_of :hero_id

  def usage(count)
    match_range = Match.order('created_at DESC').limit(count).map(&:id)
    match_ids & match_range
  end
end
