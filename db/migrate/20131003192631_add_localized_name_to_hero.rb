class AddLocalizedNameToHero < ActiveRecord::Migration
  def change
    add_column :heros, :localized_name, :string
  end
end
