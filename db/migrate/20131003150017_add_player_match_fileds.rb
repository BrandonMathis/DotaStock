class AddPlayerMatchFileds < ActiveRecord::Migration
  def change
    add_column :player_matches, :player_slot, :integer
  end
end
