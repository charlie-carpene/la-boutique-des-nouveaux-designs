require 'rails_helper'

RSpec.describe Item, type: :model do
  item = FactoryBot.create(:item)
  puts "*" * 30
  context 'stripe price' do
    it 'should have an id registered' do
      expect(item.stripe_price_id).to exist
    end
  end
end
