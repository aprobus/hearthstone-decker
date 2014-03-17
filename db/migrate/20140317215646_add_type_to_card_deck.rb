class AddTypeToCardDeck < ActiveRecord::Migration
  def change
    add_column :card_decks, :type, :string, :length => 32
  end
end
