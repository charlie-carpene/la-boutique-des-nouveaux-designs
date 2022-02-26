module ShopsHelper
	def stripe_oauth_url(session_csrf_token)
		url = "https://connect.stripe.com/oauth/authorize"
		redirect_uri = stripe_connect_url
		client_id = ENV['CLIENT_ID']
		state = session_csrf_token

		"#{url}?response_type=code&redirect_uri=#{redirect_uri}&client_id=#{client_id}&scope=read_write&state=#{state}"
	end

	def shop_address
		if @shop.address.present?
			return @shop.address
		else
			return Address.new
		end
	end

	def shop_address_url
		if @shop.address.present?
			return user_address_path(current_user.id, @shop.address.id)
		else
			return user_addresses_path(current_user.id)
		end
	end

	def shop_address_method
		if @shop.address.present?
			return :put
		else
			return :post
		end
	end

	def button_text
		if @shop.address.present?
			return "confirm_.changes"
		else
			return "create_.address"
		end
	end
end
