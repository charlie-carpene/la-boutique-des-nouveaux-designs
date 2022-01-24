module ItemsHelper
  def item_fallback_picture_url(nbr)
    return ActionController::Base.helpers.image_url("img_items/adnd_squarre_#{nbr}.svg")
  end
end
