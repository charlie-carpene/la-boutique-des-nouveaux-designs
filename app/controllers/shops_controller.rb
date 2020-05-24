class ShopsController < ApplicationController
  load_resource :only => [:show, :edit, :update, :index]
  authorize_resource

  def new
    unless current_user.present?
      flash[:alert] = "Veuillez d'abord vous connecter ou créer un compte pour pouvoir devenir artisan."
      redirect_to new_user_session_path
    end
  end

  def create
    @user = User.find(current_user.id)

    # if needed, check again https://github.com/shrinerb/shrine/blob/master/doc/multiple_files.md#4a-form-upload
    if params[:files].blank?
      flash[:error] = "Vous n'avez ajouter aucun document"
      redirect_to new_shop_path
    else
      if @user.shop.blank?
        @user.shop = Shop.new(shop_permitted_params)
        if @user.save
          AdminMailer.new_shop_request(@user, params[:files]).deliver_now
          UserMailer.new_shop_request(@user, params[:files]).deliver_now
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
    puts "-" * 30
    puts shop_permitted_params.inspect
    puts "-" * 30
    if @shop.update(shop_permitted_params)
      flash[:success] = "Les informations de votre boutique ont bien été mises à jour."
      redirect_to edit_shop_path(@shop.id)
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

  def index
  end

  private

  def shop_permitted_params
    params.require(:shop).permit(:brand, :website, :email_pro, :description, :terms_of_service, :image)
  end

end
