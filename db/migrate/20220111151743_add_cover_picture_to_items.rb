class AddCoverPictureToItems < ActiveRecord::Migration[6.1]
  def change
    add_column :items, :cover_picture, :integer

    reversible do |dir|
      dir.up do
        Item.find_each do |item|
          item.cover_picture = item.item_pictures.last.id
          item.save
        end
      end
    end
  end
end
