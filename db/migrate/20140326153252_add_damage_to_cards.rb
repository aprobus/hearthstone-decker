class AddDamageToCards < ActiveRecord::Migration
  def change
    add_column :cards, :damage, :integer
    add_column :cards, :rarity, :string, :length => 16 
  end
end

