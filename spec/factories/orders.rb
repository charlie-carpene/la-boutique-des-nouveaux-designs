FactoryBot.define do
	factory :order do
		tracking_id { }
		association :user
		association :address
	end
end
