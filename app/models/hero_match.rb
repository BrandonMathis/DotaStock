class HeroMatch < ActiveRecord::Base
  # attr_accessible :title, :body
  belongs_to :hero
  belongs_to :match
end
