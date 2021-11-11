class ShopsController < ApplicationController
  load_resource :only => [:show, :edit, :update, :index]
  authorize_resource

  def new
    unless current_user.present?
      flash[:alert] = t("shop.errors.connect_to_become_maker")
      redirect_to new_user_session_path
    end
  end

  def create
    if current_user
      @user = User.find(current_user.id)
      if @user.shop.blank?
        @user.shop = Shop.new(shop_permitted_params)
        if @user.save
          AdminMailer.new_shop_request(@user, params[:files]).deliver_now
          UserMailer.new_shop_request(@user, params[:files]).deliver_now
          flash[:success] = t("shop.success.shop_created")
          redirect_to user_path(@user)
        else
          flash[:error] = translate_error_messages(@user.shop.errors)
          redirect_to new_shop_path
        end
      else
        flash[:error] = t("shop.errors.already_exist")
        redirect_to user_path(@user)
      end
    else
      flash[:error] = t("shop.errors.connect_to_become_maker")
      redirect_to new_user_session_path
    end
  end

  def show
    session[:_csrf_token] = form_authenticity_token
    @session_csrf_token = masked_authenticity_token(session)
  end

  def edit
  end

  def update
    if @shop.update(shop_permitted_params)
      flash[:success] = t("shop.success.shop_updated")
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
      flash[:success] = t("shop.success.shop_destroyed", brand: @shop.brand, email: @shop.email_pro)
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
    params.require(:shop).permit(:brand, :website, :email_pro, :rich_description, :company_id, :terms_of_service, :image)
  end

end
