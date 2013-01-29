class CreatePlayers < ActiveRecord::Migration
  def change
    create_table :players do |t|
      t.string :account_id
      t.references :hero
      t.references :match

      t.timestamps
    end
  end
end
