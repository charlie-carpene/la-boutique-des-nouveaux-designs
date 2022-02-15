module OrdersHelper
  def handle_tracking_link(order)
    if order.tracking_id.present?
      return render(LinkComponent.new(
				title: "#{t("order.tracking_id")} #{order.tracking_id}",
				link: "https://www.laposte.fr/outils/suivre-vos-envois?code=#{order.tracking_id}",
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
end
