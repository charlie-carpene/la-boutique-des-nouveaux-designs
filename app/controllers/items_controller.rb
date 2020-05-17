class ItemsController < ApplicationController
  load_and_authorize_resource
  skip_load_resource only: :create

  def new
  end

  def create
    if params[:files].blank?
      flash[:error] = "Vous n'avez ajouter aucune photos"
      render 'new'
    else
      new_item_pictures_attributes = params[:files].inject({}) do |hash, file|
        hash.merge!(SecureRandom.hex => { picture: file })
      end
      item_pictures_attributes = item_permitted_params[:item_pictures_attributes].to_h.merge(new_item_pictures_attributes)
      item_permitted_attributes = item_permitted_params.merge(item_pictures_attributes: item_pictures_attributes)

      @item = Item.new(item_permitted_attributes)
      if @item.save
        flash[:success] = "Le produit à bien été enregistré."
        redirect_to shop_path(@item.shop_id)
      else
        flash[:error] = translate_error_messages(@item.errors)
        render 'new'
      end
    end
  end

  def show
  end

  def edit
  end

  private

  def item_permitted_params
    params.require(:item).permit(:name, :category_id, :description, :price, :available_qty, :shop_id,  :item_pictures_attributes)
  end

end
