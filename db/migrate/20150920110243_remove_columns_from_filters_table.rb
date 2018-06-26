class RemoveColumnsFromFiltersTable < ActiveRecord::Migration
  def change
  	remove_column :filters, :widgetid
  	remove_column :filters, :boardid
  end
end
