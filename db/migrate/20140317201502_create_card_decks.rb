class CreateCardDecks < ActiveRecord::Migration
  def change
    create_table :card_decks do |t|
      t.integer :user_id, :null => false
      t.integer :hero_id, :null => false
      t.string :name, :length => 64, :null => false

      t.timestamps
    end
  end
end
