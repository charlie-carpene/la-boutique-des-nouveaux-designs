require 'rails_helper'
require 'stripe_mock'
require './spec/support/stripe_helpers.rb'

RSpec.describe Shop, type: :model do
  let(:shop) { create(:shop) }

  context 'creation' do
    it 'should have a user that is a maker' do
      expect(shop.user.is_maker).to be_truthy
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

    it 'must be valid' do
      
    end
  end

  context 'method' do
    it 'shop_image' do
      expect(shop.show_image).to be_kind_of(String)
    end

    it 'verify_company_id' do
      expect(shop.verify_company_id).to be_kind_of(String)
    end
  end
end

# ToDo
# -> connexion à stripe (peut recevoir payement si le compte est connecté, sinon non)
# -> A bien toute les caractéristiques (brand, email, etc)
# -> a bien une adresse, un user & des items
# -> changer le plugin Shrine de version à derivatives + implémenter les tests