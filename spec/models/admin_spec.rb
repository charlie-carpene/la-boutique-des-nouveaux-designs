require 'rails_helper'

RSpec.describe Admin, type: :model do
  let!(:user) { create(:user) }
  let!(:admin) { create(:admin, user: user) }

  it 'should create a valid instance of Admin' do
    expect(admin).to be_valid
  end

  it 'should make a user Admin' do
    expect(user.admin.present?).to be_truthy
  end
end
