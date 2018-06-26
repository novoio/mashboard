class AddFilterWidgetRelation < ActiveRecord::Migration
  def change
  	add_reference :filters, :widget, index: true
  end
end
