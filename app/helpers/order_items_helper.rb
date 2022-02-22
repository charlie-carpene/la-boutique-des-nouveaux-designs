module OrderItemsHelper

  def items
    return Item.where(shop: @shop)
  end

  def order_items
    return OrderItem.where(item: items)
  end

  def orders
    return Order.where(order_items: order_items).order("created_at DESC")
  end
end
