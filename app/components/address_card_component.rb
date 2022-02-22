# frozen_string_literal: true

class AddressCardComponent < ViewComponent::Base
  with_collection_parameter :address

  def initialize(address:, user:, type: :edit)
    @address = address
    @user = user
    @type = type
    @on_submit_method = :get
  end

  def on_click_url(type)
    case type
    when :edit
      return @url = edit_user_address_path(@user.id, @address.id)
    when :delivery_address
      @on_submit_method = :put
      return @url = user_path(@user.id, user: { delivery_address: @address.id })
    else
    end
  end

  def selected
    if @user.delivery_address.present? && @user.delivery_address == @address.id
      return true
    else
      return false
    end
  end
end
