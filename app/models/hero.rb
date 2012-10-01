class Hero < ActiveRecord::Base
  attr_accessible :hero_id, :name
  has_many :players

  validates_presence_of :hero_id

  def usage(count)
    last_match = Match.order('created_at DESC').limit(count).last
    players.where('match_id > ?', last_match.id)
  end
end
