class CreatePlayerHeros < ActiveRecord::Migration
  def change
    create_table :player_heros do |t|
      t.references :player
      t.references :hero
      t.timestamps
    end
  end
end
