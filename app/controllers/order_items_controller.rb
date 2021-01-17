class OrderItemsController < ApplicationController
    def index
        @shop = Shop.find_by(user: current_user)
        @items = Item.where(shop: @shop)
        @order_items = OrderItem.where(item: @items)
    end
end
