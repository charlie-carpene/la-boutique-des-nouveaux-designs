class CartItemsController < ApplicationController
  load_resource

  def create
    puts "-" * 30
    puts params.inspect
    puts "-" * 30
    @cart_item = CartItem.new(cart_items_permitted_params)
    if @cart_item.save
      flash[:success] = "L'article a bien été ajouté à votre panier."
      redirect_back(fallback_location: root_path)
    else
      flash.now[:error] = translate_error_messages(@cart_item.errors)
      redirect_to root_path
    end

  end

  def update
  end

  def destroy
  end

  private

  def cart_items_permitted_params
    params.permit(:cart_id, :item_id, :item_qty_in_cart)
  end
end
