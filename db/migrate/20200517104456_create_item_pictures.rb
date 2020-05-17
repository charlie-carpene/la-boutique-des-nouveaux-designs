class CreateItemPictures < ActiveRecord::Migration[6.0]
  def change
    create_table :item_pictures do |t|
      t.references :item, null: false, foreign_key: true
      t.text :picture_data

      t.timestamps
    end
  end
end
