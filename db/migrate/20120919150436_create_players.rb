class CreatePlayers < ActiveRecord::Migration
  def change
    create_table :players do |t|
      t.string :account_id

      t.timestamps
    end
  end
end
