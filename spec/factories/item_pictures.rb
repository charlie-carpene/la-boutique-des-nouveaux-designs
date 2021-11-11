require 'faker'
require './spec/support/shrine_helpers.rb'

FactoryBot.define do
  factory :item_picture do
    picture_data { TestData.picture_data }
    association :item
  end
end
