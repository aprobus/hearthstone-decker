class AddUserIdIndexToCardDecks < ActiveRecord::Migration
  def change
    add_index :card_decks, :user_id
  end
end
