module CartsHelper
  def get_items_from(shop)
    @items = @cart.get_items_from_a_specific_shop(shop)
  end

  def set_package
    @package = package(@items)
  end

  def disabling_shop_button(shop)
    if !@package.is_valide
      @cart.errors.add(:maker_shop, t("button.disabled.item_values_error", shop: shop.brand))
      return true
    elsif !shop.address.present?
      @cart.errors.add(:maker_shop, t("button.disabled.add_maker_address", shop: shop.brand))
      return true
    else
      return false
    end
  end
end
