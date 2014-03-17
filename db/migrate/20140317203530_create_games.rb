class CreateGames < ActiveRecord::Migration
  def change
    create_table :games do |t|
      t.integer :user_id, :null => false
      t.integer :card_deck_id, :null => false
      t.integer :hero_id, :null => false
      t.string :mode, :null => false, :length => 8
      t.boolean :win_ind

      t.timestamps
    end
  end
end
