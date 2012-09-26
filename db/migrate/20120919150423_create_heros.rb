class CreateHeros < ActiveRecord::Migration
  def change
    create_table :heros do |t|
      t.integer :hero_id
      t.string :name

      t.timestamps
    end
  end
end
