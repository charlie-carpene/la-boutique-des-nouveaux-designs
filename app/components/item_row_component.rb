# frozen_string_literal: true

class ItemRowComponent < ViewComponent::Base
  def initialize(item:, order: nil)
    @item = item
    @order = order
  end
end
