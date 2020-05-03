class CreateShopImages < ActiveRecord::Migration[6.0]
  def change
    create_table :shop_images do |t|
      t.references :shop, null: false, foreign_key: true
      t.string :label
      t.text :image_data

      t.timestamps
    end
  end
end
