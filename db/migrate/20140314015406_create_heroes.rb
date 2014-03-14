class CreateHeroes < ActiveRecord::Migration
  def change
    create_table :heroes do |t|
      t.string :name, :length => 16, :null => false

      t.timestamps
    end
  end
end
