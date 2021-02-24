require 'rails_helper'

RSpec.describe Item, type: :model do
  before do
    @categories = FactoryBot.create_list(:category, 4)
    @item = FactoryBot.create(:item, categories: @categories.sample)
    puts "_"  *  30
    puts Category.all.inspect
    puts "_"  *  30
    puts Item.all.inspect
    puts "_"  *  30
    puts Shop.all.inspect
    puts "_"  *  30
    puts User.all.inspect
    puts "_"  *  30
  end

  context 'creation' do
    #it 'needs to have a description' do
    #  expect(@item.description).to be_kind_of(String)
    #end

    it 'needs to be linked to a shop and a category' do
      expect(@item.shop).to be_truthy
      expect(@item.categories).to be_truthy
    end
  end

  context 'update' do
    it 'can have one or more category' do
      expect(@item.categories).to include(a_kind_of(Category))
    end
  end
end
