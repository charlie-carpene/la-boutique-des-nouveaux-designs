require 'rails_helper'

RSpec.describe Category, type: :model do
  before do
    @categories = FactoryBot.create_list(:category, 4)
    puts "*"  *  30
    puts Category.all.inspect
    puts "*"  *  30
    puts Item.all.inspect
    puts "*"  *  30
    puts Shop.all.inspect
    puts "*"  *  30
    puts User.all.inspect
    puts "*"  *  30
  end

  context 'creation' do
    it 'needs to have a name' do
      expect(@categories.sample.name).to be_kind_of(String)
    end
  end
end
