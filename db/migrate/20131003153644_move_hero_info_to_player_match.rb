class MoveHeroInfoToPlayerMatch < ActiveRecord::Migration
  def change
    drop_table :player_heros
    add_column :player_matches, :hero_id, :integer
  end
end
