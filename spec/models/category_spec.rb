require 'rails_helper'

RSpec.describe Category, type: :model do
  before do
    @shop = create(:shop)
    @category_with_items = create(:category_with_items, items_count: 2, shop: @shop)
    @categories = FactoryBot.create_list(:category, 3)
    @item = create(:item, categories: [@categories[1]], shop: @shop)
    puts "*"  *  30
    puts Category.all.inspect
    puts "*"  *  30
    puts Item.all.inspect
    puts "*"  *  30
    puts Shop.all.inspect
    puts "*"  *  30
    puts User.all.inspect
    puts "*"  *  30
  end

  context 'creation' do
    it 'need to persist' do
      expect(Category.count).to eq(4)
    end

    it 'needs to have a name' do
      expect(@categories.sample.name).to be_kind_of(String)
    end

    it 'can have one or more item(s)' do      
      expect(@categories[0].items.count).to eq(0)
      expect(@categories[1].items.count).to eq(1)
      expect(@category_with_items.items.count).to be > 1
    end
  end
end
