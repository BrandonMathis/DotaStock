class Player < ActiveRecord::Base
  attr_accessible :account_id
  belongs_to :hero
  belongs_to :match
end
