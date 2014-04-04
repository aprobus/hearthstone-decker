class AddOrderedIndexes < ActiveRecord::Migration
  def change
    remove_index :games, { :column => :card_deck_id }
    remove_index :card_decks, { :column => :user_id }

    add_index(:games, :card_deck_id, :order => { :created_at => :desc })
    add_index(:card_decks, :user_id, :order => { :created_at => :desc })
  end
end
