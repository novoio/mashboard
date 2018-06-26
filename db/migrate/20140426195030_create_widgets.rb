class CreateWidgets < ActiveRecord::Migration
  def change
    create_table :widgets do |t|
      t.integer :userid
      t.text :sources
      t.string :type

      t.timestamps
    end
  end
end
