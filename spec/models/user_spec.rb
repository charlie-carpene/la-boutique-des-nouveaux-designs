require 'rails_helper'

RSpec.describe User, type: :model do
  let!(:user) { create(:user) }
  let!(:maker) { create(:user, :is_maker) }
  let!(:address) { create(:address, user: user)}

  context 'registration' do
    it 'should create a valid instance of User' do
      expect(user).to be_valid
    end

    it 'cannot have the same email as someone already registered' do
      create(:user, email: "gawain@yopmail.com")
      expect{ create(:user, email: "gawain@yopmail.com") }.to raise_error(ActiveRecord::RecordInvalid)
    end
  end

  context 'when maker' do
    it 'should be registered as a maker in database' do
      expect(maker.is_maker).to be_truthy
      expect(user.is_maker).to be_falsey
    end

    it 'should have a shop' do
      expect(maker.shop.present?).to be_truthy
    end
  end

  context 'method' do
    it "personnal_addresses should only return a user's personnal addresses" do
      expect(user.personnal_addresses.first).to eq(address)
      expect(maker.personnal_addresses.present?).to be_falsey
    end
  end
end
