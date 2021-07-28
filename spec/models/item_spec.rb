require 'rails_helper'

RSpec.describe Item, type: :model do
  let(:shop) { create(:shop) }
  let(:categories) { create_list(:category, 4) }
  let(:item) { create(:item, categories: [categories.sample], shop: shop) }

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
      #expect(item.item_pictures.count).to be > 0
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
      first_description = item.description
      item.name = Faker::Creature::Cat.name
      item.description = Faker::Lorem.paragraph(sentence_count: 2)
      item.save
      expect(first_name).not_to eql(Stripe::Product.retrieve(item.stripe_product_id)["name"])
      expect(first_description).not_to eql(Stripe::Product.retrieve(item.stripe_product_id)["description"])
    end
  end
end
