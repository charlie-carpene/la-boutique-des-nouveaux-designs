class UpdateItemAndCategoryRelationship < ActiveRecord::Migration[6.1]
  def change  
    remove_foreign_key :items, column: :category_id
  end
end
