module ItemsHelper
  def item_fallback_picture_url(nbr)
    return ActionController::Base.helpers.image_url("img_items/adnd_squarre_#{nbr}.svg")
  end

  def show_total_price
    @package = package(@item)

    if @package.is_valide 
      data = "<p>#{t("item.show.price")} <strong>#{t('currency_html', price: @item.price + @package.shipping_price)}</strong><br/><small class='font-italic'>#{t("item.show.shipping_fee", price: @package.shipping_price)}</small>.</p>"
      return data.html_safe
    else
      errors = ""
        @package.errors.each do |error, index| 
          errors += "<p class='font-italic'><small>#{error}</small></p>"
        end
      return errors.html_safe
    end
  end
end
