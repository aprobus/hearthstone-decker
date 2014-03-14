class CreateCards < ActiveRecord::Migration
  def change
    create_table :cards do |t|
      t.string :name, :null => false, :length => 32
      t.string :card_text, :length => 128
      t.string :card_type, :null => false, :length => 8
      t.integer :mana
      t.integer :health
      t.integer :hero_id

      t.timestamps
    end
  end
end
