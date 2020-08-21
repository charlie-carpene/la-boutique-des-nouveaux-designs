class AddProductWeightToItems < ActiveRecord::Migration[6.0]
  def change
    add_column :items, :product_weight, :integer
  end
end
