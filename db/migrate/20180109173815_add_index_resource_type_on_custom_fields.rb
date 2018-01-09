class AddIndexResourceTypeOnCustomFields < ActiveRecord::Migration
  def change
    add_index :custom_fields, :resource_type
  end
end
