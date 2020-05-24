class AddImageDataToShops < ActiveRecord::Migration[6.0]
  def change
    add_column :shops, :image_data, :text
  end
end
