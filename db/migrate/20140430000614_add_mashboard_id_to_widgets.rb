class AddMashboardIdToWidgets < ActiveRecord::Migration
  def change
    add_column :widgets, :Mashboard_ID, :string
  end
end
