# frozen_string_literal: true

class OrderedItemComponent < ViewComponent::Base
  def initialize(order_item:)
    @order_item = order_item
  end
end
