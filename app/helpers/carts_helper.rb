module CartsHelper
  def get_items_from(shop)
    @items = @cart.get_items_from_a_specific_shop(shop)
  end

  def set_package
    @package = package(@items)
  end
end
