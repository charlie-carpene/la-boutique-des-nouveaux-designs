require 'rails_helper'

RSpec.describe Category, type: :model do
  before do
    @categories = FactoryBot.build_list(:category, 4)
  end

  context 'creation' do
    it 'needs to have a name' do
      expect(@categories.sample.name).to be_kind_of(String)
    end
  end
end
