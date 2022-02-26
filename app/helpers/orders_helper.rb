module OrdersHelper
  def handle_tracking_link(order)
    if order.tracking_id.present?
      return render(LinkComponent.new(
				title: "#{t("order.tracking_id")} #{order.tracking_id}",
				link: order.tracking_url,
				html_options: { target: "_blank", rel: "nofollow" }
			))
    else 
      return render(LinkComponent.new(
        title: t("order.tracking_id_missing"),
        link: "#",
        html_options: { style: "color: var(--dark); pointer-events: none;" }
      ))
    end
  end

  def disabling_checkout_button
    if !@order.user.addresses.exists? || !@order.user.addresses.where(id: @order.user.delivery_address).exists?
      @order.errors.add(:add_address, t("button.disabled.add_user_address"))
      return true
    elsif !@ordered_cart_items.first.item.shop.address.present?
      @order.errors.add(:maker_shop, t("button.disabled.add_maker_address", shop: @ordered_cart_items.first.item.shop.brand))
      return true
    else
      return false
    end
  end
end
