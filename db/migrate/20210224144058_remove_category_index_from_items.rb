class RemoveCategoryIndexFromItems < ActiveRecord::Migration[6.1]
  def change
    remove_index :items, :category_id
    remove_column :items, :category_id, type: :bigint, null: false
  end
end
