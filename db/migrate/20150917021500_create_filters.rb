class CreateFilters < ActiveRecord::Migration
  def change
    create_table :filters do |t|
      t.string :filter
      t.integer :widgetid
      t.integer :boardid

      t.timestamps
    end
  end
end
