require 'rails_helper'

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
    it 'must exist' do
      expect(shop.can_receive_payments?).to be(true)
    end

    it 'must be valid' do
      
    end
  end

  context 'method' do
    it 'shop_image(shop)' do
      expect(shop.show_image(shop)).to be_kind_of(String)
    end
  end
end

# ToDo
# -> connexion à stripe (peut recevoir payement si le compte est connecté, sinon non)
# -> A bien toute les caractéristiques (brand, email, etc)
# -> a bien une adresse, un user & des items
# -> changer le plugin Shrine de version à derivatives + implémenter les tests