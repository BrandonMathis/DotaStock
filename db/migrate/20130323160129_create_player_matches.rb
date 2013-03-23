class CreatePlayerMatches < ActiveRecord::Migration
  def change
    create_table :player_matches do |t|
      t.references :match
      t.references :player
      t.timestamps
    end
  end
end
