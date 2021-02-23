require 'rails_helper'

RSpec.describe User, type: :model do
  before do
    @maker = FactoryBot.build(:user, :is_maker, email: "gradya@yopmail.com")
    @user = FactoryBot.build(:user)
    puts "-"  *  30
    puts Category.all.inspect
    puts "-"  *  30
    puts Item.all.inspect
    puts "-"  *  30
    puts Shop.all.inspect
    puts "-"  *  30
    puts User.all.inspect
    puts "-"  *  30
  end

  context 'registration' do
    it 'cannot have the same email as someone already registered' do
      expect(@user.email).to match("gawain@yopmail.com")
    end
  end

  context 'that is a maker' do
    it 'should be registered as so in the databased' do
      expect(@maker.is_maker).to be_truthy
      expect(@user.is_maker).to be_falsey
    end
  end

  context 'that is a maker' do
    it 'should have a shop' do
      expect(@maker.shop).to be_truthy
    end
  end
end
