class DropPlayerHero < ActiveRecord::Migration
  def change
    drop_table :hero_matches
  end
end
