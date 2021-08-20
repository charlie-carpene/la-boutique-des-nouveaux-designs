require 'rails_helper'

RSpec.describe ItemPicture, type: :model do
	let(:shop) { create(:shop) }
	let(:categories) { create_list(:category, 4) }  
	let(:item_with_pictures) { create(:item_with_pictures, categories: [categories.sample], shop: shop) }

	it 'should create a valid instance of Picture' do
		expect(item_with_pictures.item_pictures.first).to be_valid
	end

	it 'max number is 10 per item' do
		expect{ create(:item_with_pictures, pictures_count: 11, categories: [categories.sample], shop: shop) }.to raise_error
	end
end
