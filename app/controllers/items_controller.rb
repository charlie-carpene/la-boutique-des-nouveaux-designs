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
      # if needed, check again https://github.com/shrinerb/shrine/blob/master/doc/multiple_files.md#4a-form-upload
      item_permitted_attributes = get_item_permitted_attributes #private method

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

  def update
    if params[:files].blank?
      item_permitted_attributes = item_permitted_params
    elsif
      @item.item_pictures.destroy_all
      item_permitted_attributes = get_item_permitted_attributes
    end

    if @item.update(item_permitted_attributes)
      flash[:success] = "Les informations de #{@item.name} ont bien été mises à jour."
      redirect_to item_path(@item.id)
    else
      flash.now[:error] = translate_error_messages(@item.errors)
      render 'edit'
    end
  end

  def destroy
    @item.destroy
    flash[:error] = "L'article a bien été supprimé."
    redirect_back(fallback_location: root_path)
  end

  private

  def item_permitted_params
    params.require(:item).permit(:name, :category_id, :description, :price, :available_qty, :product_weight, :shop_id,  :item_pictures_attributes)
  end

  def get_item_permitted_attributes
    new_item_pictures_attributes = params[:files].inject({}) do |hash, file|
      hash.merge!(SecureRandom.hex => { picture: file })
    end
    item_pictures_attributes = item_permitted_params[:item_pictures_attributes].to_h.merge(new_item_pictures_attributes)
    return item_permitted_params.merge(item_pictures_attributes: item_pictures_attributes)
  end

end
