class CreateCardDeckCards < ActiveRecord::Migration
  def change
    create_join_table :card_decks, :cards do |t|
      t.index :card_deck_id
    end
  end
end
