require 'rails_helper'

RSpec.describe Category, type: :model do
  let!(:shop) { create(:shop) }
  let!(:category_with_items) { create(:category_with_items, items_count: 2, shop: shop) }
  let!(:categories) { create_list(:category, 3) }
  let!(:item) { create(:item, categories: [categories[1]], shop: shop) }

  it 'should create a valid instance of Category' do
    expect(category_with_items).to be_valid
  end

  context 'creation' do
    it 'need to persist' do
      expect(Category.count).to eq(4)
    end

    it 'can have one or more item(s)' do
      expect(categories.sample).to have_many(:items)
      expect(category_with_items.items.count).to be > 1
    end
  end
end
