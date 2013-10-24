class CreateIndexes < ActiveRecord::Migration
  def up
    add_index :player_matches, :hero_id, name: 'hero_id_index'
  end

  def down
    remove_index :player_matches, name: :match_id_index
    remove_index :player_matches, name: :player_id_index
    remove_index :player_matches, name: :hero_id_index
  end
end
