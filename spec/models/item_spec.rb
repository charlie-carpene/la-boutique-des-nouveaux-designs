require 'rails_helper'

RSpec.describe Item, type: :model do
  before do
    @maker = FactoryBot.create(:user, :is_maker)
    @categories = FactoryBot.create_list(:category, 4)
    @shop = FactoryBot.create(:shop, user: @maker)
    @item = FactoryBot.build(:item, category: @categories[0], shop: @shop)
  end

  context 'creation' do
    it 'needs to have a description' do
      expect(@item.description).to be_kind_of(String)
    end
  end
end
