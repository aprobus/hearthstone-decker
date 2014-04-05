class CreateGameImports < ActiveRecord::Migration
  def change
    create_table :game_imports do |t|
      t.integer :user_id, :null => false
      t.string :file_name, :null => false, :length => 64

      t.timestamps
    end

    add_index :game_imports, :user_id

    add_column :games, :game_import_id, :integer
    add_index :games, :game_import_id

    add_column :card_decks, :game_import_id, :integer
    add_index :card_decks, :game_import_id

    add_foreign_key :games, :game_imports
    add_foreign_key :card_decks, :game_imports
    add_foreign_key :game_imports, :users

  end
end

