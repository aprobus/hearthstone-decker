class ChangeCardDecksAllowNullName < ActiveRecord::Migration
  def change
    change_column :card_decks, :name, :string, :null => true, :length => 64
  end
end
