class CartItemsController < ApplicationController
  load_and_authorize_resource except: :create
  load_resource only: :create

  def create
    @cart_item = CartItem.new(cart_items_permitted_params)

    unless @cart_item.cart == (current_user ? current_user.cart : nil)
      flash[:error] = t("ability.errors.action_not_allowed")
      redirect_back(fallback_location: root_path) and return
    end

    if @cart_item.item.available_qty - params[:item_qty_in_cart].to_i >= 0
      if @cart_item.cart == current_user.cart && @cart_item.item == current_user.cart.items.where(id: params[:item_id]).first #check if item is already in cart
        flash[:info] = t("cart_item.info.item_already_in_cart")
        redirect_back(fallback_location: root_path)
      else
        if @cart_item.save
          flash[:success] = t("cart_item.success.item_added_to_cart")
          redirect_back(fallback_location: root_path)
        else
          flash.now[:error] = translate_error_messages(@cart_item.errors)
          redirect_to root_path
        end
      end
    else
      flash[:error] = t("cart_item.errors.item_qty_too_low")
      redirect_back(fallback_location: root_path)
    end
  end

  def update
    case params[:operation]
    when "plus"
      if @cart_item.add_qty_if_available_enough
        redirect_to cart_path(current_user.cart.id), status: :see_other
      else
        flash[:error] = t("cart_item.errors.item_qty_too_low")
        redirect_back(fallback_location: root_path)
      end
    when "minus"
      if @cart_item.remove_qty
        redirect_to cart_path(current_user.cart.id), status: :see_other
      else
        flash[:error] = t("cart_item.errors.delete_item_from_cart")
        redirect_back(fallback_location: root_path)
      end
    else
      flash[:error] = t("cart_item.errors.action_dont_exist")
      redirect_back(fallback_location: root_path)
    end
  end

  def destroy
    if @cart_item.destroy
      flash[:alert] = t("cart_item.errors.item_deleted_from_cart", name: @cart_item.item.name)
      redirect_back fallback_location: root_path, status: :see_other
    else
      redirect_back(fallback_location: root_path)
    end
  end

  private

  def cart_items_permitted_params
    params.permit(:cart_id, :item_id, :item_qty_in_cart, :operation)
  end
end
