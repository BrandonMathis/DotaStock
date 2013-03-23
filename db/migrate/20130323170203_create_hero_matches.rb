class CreateHeroMatches < ActiveRecord::Migration
  def change
    create_table :hero_matches do |t|
      t.references :hero
      t.references :match
      t.timestamps
    end
  end
end
