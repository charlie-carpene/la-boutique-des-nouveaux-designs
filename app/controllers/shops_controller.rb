class ShopsController < ApplicationController

  def new
    unless current_user.present?
      flash[:alert] = "Veuillez d'abord vous connecter ou créer un compte pour pouvoir devenir artisan."
      redirect_to new_user_session_path
    end
  end

  def create
    @user = User.find(current_user.id)
    unless @user.shop.present?
      @user.shop = Shop.create(shop_permitted_params)
      if @user.save
        flash[:success] = "Votre demande a bien été envoyé"
        redirect_to user_path(@user)
      else
        flash[:error] = translate_error_messages(@user.shop.errors)
        redirect_to new_shop_path
      end
    else
      flash[:error] = "Vous avez déjà une Boutique enregistrée"
      redirect_to user_path(@user)
    end
  end

  private

  def shop_permitted_params
    params.require(:shop).permit(:brand, :website, :description)
  end

end
