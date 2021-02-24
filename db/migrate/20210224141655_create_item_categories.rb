class CreateItemCategories < ActiveRecord::Migration[6.1]
  def change
    create_table :item_categories do |t|
      t.references :item, null: false, foreign_key: true
      t.references :category, null: false, foreign_key: true

      t.timestamps
    end
  end
end
