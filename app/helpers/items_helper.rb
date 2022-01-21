module ItemsHelper
  def cover_picture_with_fallback(id, img_type)
    @item = Item.find(id)

    if @item.item_pictures.where(id: @item.cover_picture).exists?
      return @item.item_pictures.find(@item.cover_picture).picture_url(img_type)
    elsif @item.item_pictures.exists?
      return @item.item_pictures.last.picture_url(img_type)
    else
      return ActionController::Base.helpers.asset_path("img-items/adnd-squarre-0.jpeg", :digest => false)
    end
  end
end
