class OrderItemsController < ApplicationController
	authorize_resource
	
	def index
		@shop = Shop.find_by(user: current_user)
	end
end
