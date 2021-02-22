require 'rails_helper'

RSpec.describe User, type: :model do
  before do
    @maker = FactoryBot.build(:user, :is_maker)
    @user = FactoryBot.build(:user)
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
end
