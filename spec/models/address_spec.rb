require 'rails_helper'

RSpec.describe Address, type: :model do
  let!(:maker) { create(:user, :is_maker) }
  let!(:address) { create(:address, user: maker) }
  let!(:pro_address) { create(:address, user: maker) }

  it 'should create a valid instance of Address' do
    maker
    pro_address
    expect(address).to be_valid
  end

  it 'should belong to a user' do
    maker
    pro_address
    expect(address.user.present?).to be_truthy
  end

  it 'can belong to a shop if user is maker and need a pro address' do
    address
    maker.shop.address = pro_address

    expect(pro_address.shop.present?).to be_truthy
    expect(maker.addresses.count).to eq(2)
  end

  context 'method' do
    it 'personnal_addresses' do
      address
      maker.shop.address = pro_address
      maker.shop.address.save

      expect(maker.personnal_addresses.count).to eq(1)
      expect(maker.personnal_addresses.first.id).to eq(7)
    end
  end
end
