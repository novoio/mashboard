class RemoveColumnWidgetIdFilters < ActiveRecord::Migration
  def change
  	remove_column :filters, :widget_id
  end
end
