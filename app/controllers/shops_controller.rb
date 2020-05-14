class ShopsController < ApplicationController
  load_resource :only => [:show, :edit, :update]
  authorize_resource

  def new
    unless current_user.present?
      flash[:alert] = "Veuillez d'abord vous connecter ou créer un compte pour pouvoir devenir artisan."
      redirect_to new_user_session_path
    end
  end

  def create
    puts "-" * 30
    p params[:shop]
    puts "-" * 30
    @user = User.find(current_user.id)

    # if needed, check https://github.com/shrinerb/shrine/blob/master/doc/multiple_files.md#4a-form-upload
    if params[:files].blank?
      flash[:error] = "Vous n'avez ajouter aucun document"
      redirect_to new_shop_path
    else
      new_shop_images_attributes = params[:files].inject({}) do |hash, file|
        hash.merge!(SecureRandom.hex => { image: file })
      end
      shop_images_attributes = shop_permitted_params[:shop_images_attributes].to_h.merge(new_shop_images_attributes)
      shop_permitted_attributes = shop_permitted_params.merge(shop_images_attributes: shop_images_attributes)
      if @user.shop.blank?
        shop = Shop.new(shop_permitted_attributes)
        shop.user = @user
        if shop.save
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
  end

  def show
  end

  def edit
  end

  def update
    if @shop.update(shop_permitted_params)
      flash[:success] = "Les informations de votre boutique ont bien été mises à jour."
      redirect_to shop_path(@shop.id)
    else
      flash.now[:error] = translate_error_messages(@shop.errors)
      render 'edit'
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
    params.require(:shop).permit(:brand, :website, :email_pro, :description, :terms_of_service, :shop_images_attributes)
  end

end
