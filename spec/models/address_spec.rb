require 'rails_helper'

RSpec.describe Address, type: :model do
  let!(:address) { create(:address) }

  it 'should create a valid instance of Admin' do
    expect(address).to be_valid
  end

  it 'should belong to a user' do
    expect(address.user.present?).to be_truthy
  end

  it 'can belong to a shop if user is maker and need a pro address' do
    maker = create(:user, :is_maker, email: "gradya@yopmail.com")
    personnal_address = create(:address, user: maker)
    pro_address = create(:address, user: maker, shop: shop)
    #pro_address.shop = maker.shop

    expect(pro_address.shop.present?).to be_truthy
  end
end
