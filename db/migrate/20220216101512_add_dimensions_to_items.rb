class AddDimensionsToItems < ActiveRecord::Migration[6.1]
  def change
    add_column :items, :width, :integer
    add_column :items, :height, :integer
    add_column :items, :depth, :integer
    add_column :items, :weight, :integer

    reversible do |dir|
      dir.up do
        Item.all.each do |item|
          item.weight = item.product_weight
          item.save
        end
      end

      dir.down do
        Item.all.each do |item|
          item.product_weight = item.weight
          item.save
        end
      end
    end

    remove_column :items, :product_weight, :integer
  end
end
