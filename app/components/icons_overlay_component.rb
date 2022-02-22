# frozen_string_literal: true

class IconsOverlayComponent < ViewComponent::Base
  def initialize(item:, user: nil)
    @item = item
    @user = user
  end

  def can_user?(action, subject)
    ability = Ability.new(@user)
    return ability.can?(action, subject)
  end
end
