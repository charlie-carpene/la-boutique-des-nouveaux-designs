require 'rails_helper'

RSpec.describe Category, type: :model do
  let!(:shop) { create(:shop) }
  let(:category_with_items) { category_with_item_s(items_count: 3, item_shop: shop) }
  let(:categories) { create_list(:category, 3) }
  let!(:item) { item_s_with_pictures(categories: [categories[1]], shop: shop).first }

  it 'should create a valid instance of Category' do
    expect(category_with_items).to be_valid
  end

  context 'creation' do
    it 'need to persist' do
      expect{ create_list(:category, 3) }.to change(Category, :count).by(3)
    end

    it 'can have one or more item(s)' do
      expect(categories.sample).to have_many(:items)
      expect(category_with_items.items.count).to be > 1
    end
  end
end
