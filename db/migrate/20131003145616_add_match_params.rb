class AddMatchParams < ActiveRecord::Migration
  def change
    add_column :matches, :match_seq_num, :integer
    add_column :matches, :start_time, :datetime
    add_column :matches, :lobby_type, :integer
  end
end
