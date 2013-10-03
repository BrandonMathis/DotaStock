class MakeHeroIdInteger < ActiveRecord::Migration
  def change
    remove_column :heros, :hero_id
    add_column :heros, :hero_id, :integer
  end
end
