# frozen_string_literal: true

class ItemCardComponent < ViewComponent::Base
  def initialize(item:)
    @item = item
  end
end

