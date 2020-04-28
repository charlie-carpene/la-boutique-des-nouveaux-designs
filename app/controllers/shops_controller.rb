class ShopsController < ApplicationController
  authorize_resource

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
        AdminMailer.new_shop_request(@user).deliver_now
        UserMailer.new_shop_request(@user).deliver_now
        flash[:success] = "Votre demande a bien été transmise à la boutique et un mail de confirmation vous a été envoyé."
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

  def destroy
    @user = Shop.find(params[:id]).user
    @shop = @user.shop
    @user.shop.destroy
    if @user.save
      UserMailer.new_shop_request_denied(@shop).deliver_now
      flash[:success] = "La demande a bien été rejetée et un mail pour avertir #{@shop.brand} a été envoyé à #{@shop.email_pro}."
      redirect_to root_path
    else
      flash[:error] = translate_error_messages(@user.shop.errors)
      redirect_to root_path
    end
  end

  private

  def shop_permitted_params
    params.require(:shop).permit(:brand, :website, :email_pro, :description)
  end

end
