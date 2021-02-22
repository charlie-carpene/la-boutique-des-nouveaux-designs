class AddStripeproductidToItems < ActiveRecord::Migration[6.1]
  def change
    add_column :items, :stripe_product_id, :string
  end

  def data
    Item.find_each do |item|
      stripe_price = Stripe::Price.retrieve(item.stripe_price_id)
      item.stripe_product_id = stripe_price.product
      item.save
    end
  end
end
