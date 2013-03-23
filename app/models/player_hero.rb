class PlayerHero < ActiveRecord::Base
  # attr_accessible :title, :body
  belongs_to :player
  belongs_to :hero
end
