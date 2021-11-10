require 'rails_helper'

RSpec.describe ItemPicture, type: :model do
	let(:shop) { create(:shop)}
  let(:category) { create(:category) }
  let(:item) { item_s_with_pictures(categories: [category], shop: shop).first }

	it 'should link an item with a category ' do
		expect(item.categories.first).to eq(category)
		expect(category.items.first).to eq(item)
	end
end