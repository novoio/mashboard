class Changetypename < ActiveRecord::Migration
  def change
    rename_column :widgets, :type, :widget_type
  end
end
