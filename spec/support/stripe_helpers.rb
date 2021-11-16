module StripeData
	module_function
	
	def create_maker(stripe_helper)
		Stripe::Customer.create({
			email: 'maker@yopmail.com',
			access_token: "sk_test_51GqL7aF97WawBqZDo6gbxeU1ClP2wYXNoeiFPzWE46idDIvPT74IxTFBPJI0bFsun6DKlsDmh2B3MT00gRb2EZTLoNMeNKwRde",
			stripe_publishable_key: "pk_test_51GqL7aF97WawBqZDvWhivGB3reJl9kECFjQ9nPzaAVhs6zGpaacPTNOwT2sQbXrJJWMpwRLcwrLHMf00sdzw27OAe9zT9UNLsq",
			refresh_token: "rt_K7h3biIvWkxKeNqVRl7qM1Kk2Hgv4RlTq8YuJi8SpgLyk9hx",
			source: stripe_helper.generate_card_token
		})
	end
	
	def generate_stripe_event_signature(payload)
    time = Time.now
    secret = ENV['SECRET_KEY']
    signature = Stripe::Webhook::Signature.compute_signature(time, payload, secret)
    Stripe::Webhook::Signature.generate_header(
      time,
      signature,
      scheme: Stripe::Webhook::Signature::EXPECTED_SCHEME
    )
	end

end
