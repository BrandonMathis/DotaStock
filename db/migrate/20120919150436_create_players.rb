class CreatePlayers < ActiveRecord::Migration
  def change
    create_table :players do |t|
      t.integer :account_id
      t.references :hero
      t.references :match

      t.timestamps
    end
  end
end
