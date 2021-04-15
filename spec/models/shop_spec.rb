require 'rails_helper'

RSpec.describe Shop, type: :model do
  before do
    @shop = FactoryBot.create(:shop)
    puts "/"  *  30
    puts Category.all.inspect
    puts "/"  *  30
    puts Item.all.inspect
    puts "/"  *  30
    puts Shop.all.inspect
    puts "/"  *  30
    puts User.all.inspect
    puts "/"  *  30
  end

  context 'creation' do
    it 'should have a user that is a maker' do
      expect(@shop.user.is_maker).to be_truthy
    end
  end
end

# ToDo
# -> connexion à stripe (peut recevoir payement si le compte est connecté, sinon non)
# -> A bien toute les caractéristiques (brand, email, etc)
# -> a bien une adresse, un user & des items