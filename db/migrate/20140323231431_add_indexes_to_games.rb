class AddIndexesToGames < ActiveRecord::Migration
  def change
    add_index :games, :card_deck_id
  end
end
