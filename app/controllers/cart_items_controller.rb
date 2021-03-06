class CartItemsController < ApplicationController
  load_resource

  def create
    @cart_item = CartItem.new(cart_items_permitted_params)
    if @cart_item.item.available_qty > 0
      if @cart_item.cart == current_user.cart && @cart_item.item == current_user.cart.items.where(id: params[:item_id]).first #check if item is already in cart
        flash[:info] = "Vous avez déjà ajouté l'article. Ajoutez-en plus directement depuis votre panier."
        redirect_back(fallback_location: root_path)
      else
        if @cart_item.save
          flash[:success] = "L'article a bien été ajouté à votre panier."
          redirect_back(fallback_location: root_path)
        else
          flash.now[:error] = translate_error_messages(@cart_item.errors)
          redirect_to root_path
        end
      end
    else
      flash[:error] = "L'article n'est malheureusement plus disponible."
      redirect_back(fallback_location: root_path)
    end
  end

  def update
    case params[:operation]
    when "plus"
      if @cart_item.add_qty_if_available_enough(@cart_item)
        redirect_back(fallback_location: root_path)
      else
        flash[:error] = "L'article n'est pas disponible en quantité suffisante pour en ajouter un de plus."
        redirect_back(fallback_location: root_path)
      end
    when "minus"
      if @cart_item.remove_qty(@cart_item)
        redirect_back(fallback_location: root_path)
      else
        flash[:error] = "Pour supprimer l'article, cliquez sur la corbeille."
        redirect_back(fallback_location: root_path)
      end
    else
      flash[:error] = "L'opération n'existe pas."
      redirect_back(fallback_location: root_path)
    end
  end

  def destroy
    @cart_item.destroy
    flash[:alert] = "#{@cart_item.item.name} a bien supprimé de votre panier."
    redirect_back(fallback_location: root_path)
  end

  private

  def cart_items_permitted_params
    params.permit(:cart_id, :item_id, :item_qty_in_cart, :operation)
  end
end
