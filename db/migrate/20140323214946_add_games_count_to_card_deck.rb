class AddGamesCountToCardDeck < ActiveRecord::Migration
  def change
    add_column :card_decks, :num_games_won, :integer, :default => 0
    add_column :card_decks, :num_games_lost, :integer, :default => 0
  end
end
