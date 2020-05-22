class ShopImagesController < ApplicationController
  load_and_authorize_resource

  def update
    if @shop_image.update(shop_image_permitted_params)
      flash[:success] = "Le document a bien été mis à jour."
      redirect_to shop_path(@shop_image.shop.id)
    else
      flash.now[:error] = translate_error_messages(@shop_image.errors)
      render 'edit'
    end
  end

  private

  def shop_image_permitted_params
    params.require(:shop_image).permit(:image)
  end
end
