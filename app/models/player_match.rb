class PlayerMatch < ActiveRecord::Base
  # attr_accessible :title, :body
  belongs_to :player
  belongs_to :match
end
