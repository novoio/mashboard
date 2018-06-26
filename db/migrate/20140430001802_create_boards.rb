class CreateBoards < ActiveRecord::Migration
  def change
    create_table :boards do |t|
      t.string :name
      t.string :widgets
      t.integer :userid

      t.timestamps
    end
  end
end
