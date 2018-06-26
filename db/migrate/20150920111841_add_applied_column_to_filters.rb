class AddAppliedColumnToFilters < ActiveRecord::Migration
  def change
  	add_column :filters, :is_applied, :boolean, null: true, default: false
  end
end
