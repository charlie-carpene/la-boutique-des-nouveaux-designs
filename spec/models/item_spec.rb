require 'rails_helper'

RSpec.describe Item, type: :model do
  let(:categories) { create_list(:category, 4) }
  let(:maker_with_items) { maker_with_items_in_shop(items_count: 2, categories: categories) }
  let(:user_with_items) { user_with_items_in_cart(items: maker_with_items.shop.items) }
  let(:item) { item_s_with_pictures(categories: [categories.sample], shop: maker_with_items.shop).first }

  it 'should create a valid instance of Item' do
    expect(item).to be_valid
  end

  context 'creation' do  
    it 'needs to be linked to a shop and a category' do
      expect(item.shop.brand).to be_kind_of(String)
      expect(item.categories.sample.name).to be_kind_of(String)
    end

    it 'should generate a stripe product and price' do
      expect(item.stripe_price_id).to be_truthy
      expect(item.stripe_product_id).to be_truthy
    end

    it 'should be linked to at least one picture' do
      expect(item.item_pictures.count).to be > 0
    end
  end

  context 'method' do
    it 'price_with_shipping_cost' do
      expect(item.price_with_shipping_cost(15)).to be(34)
    end

    it 'get_qty_in_cart()' do
      create(:cart_item, cart: user_with_items.cart, item: item, item_qty_in_cart: 1)
      expect(item.get_qty_in_cart(user_with_items)).to eq(1)
    end
  end

  context 'update' do
    it 'can have one or more category' do
      expect(item.categories).to include(a_kind_of(Category))
    end

    it 'change stripe price id if the price has changed' do
      item.price = Faker::Number.number(digits: 2)
      expect{ item.save }.to change{ item.stripe_price_id }
    end

    it 'change stripe price id if the price has changed' do
      first_name = item.name
      first_description = item.rich_description
      item.name = Faker::Name.first_name
      item.rich_description = Faker::Lorem.paragraph(sentence_count: 2)
      item.save
      expect(first_name).not_to eql(Stripe::Product.retrieve(item.stripe_product_id)["name"])
      expect(first_description).not_to eql(Stripe::Product.retrieve(item.stripe_product_id)["description"])
    end
  end

  context 'destroy' do
    it 'set Stripe product and price status to false' do
      expect{ item.destroy }.to change{
        Stripe::Price.retrieve(item.stripe_price_id)["active"] &&
        Stripe::Product.retrieve(item.stripe_product_id)["active"]
      }.from(true).to(false)
    end
  end
end
