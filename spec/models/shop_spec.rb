require 'rails_helper'
require 'stripe_mock'
require './spec/support/stripe_helpers.rb'

RSpec.describe Shop, type: :model do
  let(:shop) { create(:shop) }
  let(:pro_address) { create(:address, user: shop.user) }

  context 'creation' do
    it 'should create a valid instance of Shop' do
      expect(shop).to be_valid
    end
    
    it 'should have a user that is a maker' do
      expect(shop.user.is_maker).to be_truthy
    end

    it 'can have a pro address' do
      expect(shop.address).to be_falsey

      shop.address = pro_address
      expect(shop.address.zip_code.length).to eq(5)
    end
  end

  it 'siren must be valid' do
    expect(shop.siren).to be_kind_of(String)
    expect(shop.siren.length).to be(9)
  end

  context 'stripe connect info' do
    let(:stripe_helper) { StripeMock.create_test_helper }
    before { StripeMock.start }
    after { StripeMock.stop }

    it 'must exist' do
      expect(shop.can_receive_payments?).to be(false)

      stripe_maker = StripeData.create_maker(stripe_helper)
      shop.provider = "stripe_connect"
      shop.uid = stripe_maker.id
      shop.access_code = stripe_maker.access_token
      shop.publishable_key = stripe_maker.stripe_publishable_key
      shop.refresh_token = stripe_maker.refresh_token

      expect(shop.can_receive_payments?).to be(true)
    end
  end

  context 'method' do
    it 'shop_image' do
      puts "* " * 30
      puts shop.image[:shop].inspect
      puts "* " * 30
      expect(shop.show_image).to be_kind_of(String)
    end

    it 'verify_company_id' do
      expect(shop.verify_company_id).to be_kind_of(String)
    end
  end
end

# ToDo
# -> changer le plugin Shrine de version à derivatives + implémenter les tests