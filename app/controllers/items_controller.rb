class ItemsController < ApplicationController
  load_and_authorize_resource
  skip_load_resource only: :create

  def new
  end

  def create
    @item = Item.new(item_permitted_params)
    if @item.save
      flash[:success] = "Le produit à bien été enregistré."
      redirect_to shop_path(@item.shop_id)
    else
      flash[:error] = translate_error_messages(@item.errors)
      render 'new'
    end
  end

  def show
  end

  private

  def item_permitted_params
    params.require(:item).permit(:name, :category_id, :description, :price, :available_qty, :shop_id)
  end

end
