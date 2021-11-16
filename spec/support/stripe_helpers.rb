module StripeData
	module_function
	
	def create_maker(stripe_helper)
		Stripe::Customer.create({
			email: 'maker@yopmail.com',
			access_token: ENV['SECRET_KEY'],
			stripe_publishable_key: ENV['PUBLISHABLE_KEY'],
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
