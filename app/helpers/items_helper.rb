module ItemsHelper
  def cover_picture_with_fallback(id, img_type)
    @item = Item.find(id)

    if @item.item_pictures.where(id: @item.cover_picture).exists?
      return @item.item_pictures.find(@item.cover_picture).picture_url(img_type)
    elsif @item.item_pictures.exists?
      return @item.item_pictures.last.picture_url(img_type)
    else
      return ActionController::Base.helpers.image_url("img_items/adnd_squarre_0.svg")
    end
  end

  def item_fallback_picture_url(nbr)
    return ActionController::Base.helpers.image_url("img_items/adnd_squarre_#{nbr}.svg")
  end
end
