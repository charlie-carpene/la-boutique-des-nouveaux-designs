class ShopsController < ApplicationController
  load_resource :only => [:show, :edit]
  authorize_resource

  def new
    unless current_user.present?
      flash[:alert] = "Veuillez d'abord vous connecter ou créer un compte pour pouvoir devenir artisan."
      redirect_to new_user_session_path
    end
  end

  def create
    @user = User.find(current_user.id)

    # if needed, check https://github.com/shrinerb/shrine/blob/master/doc/multiple_files.md#4a-form-upload
    new_shop_images_attributes = params[:files].inject({}) do |hash, file|
      hash.merge!(SecureRandom.hex => { image: file })
    end
    shop_images_attributes = shop_permitted_params[:shop_images_attributes].to_h.merge(new_shop_images_attributes)
    shop_permitted_attributes = shop_permitted_params.merge(shop_images_attributes: shop_images_attributes)
    if @user.shop.blank?
      shop = Shop.new(shop_permitted_attributes)
      shop.user = @user
      if shop.save
        #AdminMailer.new_shop_request(@user).deliver_now
        #UserMailer.new_shop_request(@user).deliver_now
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

  def show
  end

  def edit
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
    params.require(:shop).permit(:brand, :website, :email_pro, :description, :shop_images_attributes)
  end

end
