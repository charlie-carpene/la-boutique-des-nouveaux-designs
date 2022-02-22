# frozen_string_literal: true

class ItemRowComponent < ViewComponent::Base
  def initialize(item:, order: nil, cart: nil)
    @item = item
    @order = order
    @cart = cart
  end
end
