class AddReferenceToFiltersWithWidgets < ActiveRecord::Migration
  def change
  	add_reference :filters, :widgets, index: true
  end
end
