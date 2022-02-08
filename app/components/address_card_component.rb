# frozen_string_literal: true

class AddressCardComponent < ViewComponent::Base
  with_collection_parameter :address

  def initialize(address:, user:, buttons_disable: false)
    @address = address
    @user = user
    @buttons_disable = buttons_disable
  end

end
