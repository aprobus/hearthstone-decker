class AddForeignKeys < ActiveRecord::Migration
  def up
    change_table :card_decks do |t|
      t.foreign_key :users
      t.foreign_key :heroes
    end

    change_table :games do |t|
      t.foreign_key :users
      t.foreign_key :card_decks
      t.foreign_key :heroes
    end

    change_table :cards do |t|
      t.foreign_key :heroes
    end

    change_table :card_decks_cards do |t|
      t.foreign_key :cards
      t.foreign_key :card_decks
    end
  end

  def down
    change_table :card_decks do |t|
      t.remove_foreign_key :users
      t.remove_foreign_key :heroes
    end

    change_table :games do |t|
      t.remove_foreign_key :users
      t.remove_foreign_key :card_decks
      t.remove_foreign_key :heroes
    end

    change_table :cards do |t|
      t.remove_foreign_key :heroes
    end
  end
end
