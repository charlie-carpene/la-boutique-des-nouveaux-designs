class UsersController < ApplicationController
  load_resource :only => :show
  authorize_resource

  def show
  end

  def edit
    @user_to_validate = User.find(params[:id])

    if load_user.admin.present? && @user_to_validate.shop.present? #can't use load_and_authorize_resource because it takes the params from the URL and here we want the current_user id
      @legal_compagny_name = @user_to_validate.shop.verify_company_id
    else 
      flash[:error] = t('errors.admin_required') + ' / ' + t('shop.dont_exist')
      redirect_to root_path
    end
  end

  def update
    @user_to_validate = User.find(params[:id])

    if user_permitted_params[:is_maker].present? && load_user.admin.present?
      if @user_to_validate.update(user_permitted_params)
        UserMailer.new_shop_request_accepted(@user_to_validate).deliver_now
        flash[:success] = t("user.update.success.validate_user_as_maker", brand: @user_to_validate.shop.brand, shop_email: @user_to_validate.shop.email_pro)
        redirect_to root_path
      else
        flash[:error] = t('errors.admin_required') + ' / ' + translate_error_messages(@user_to_validate.shop.errors).join(', ')
        redirect_to root_path
      end
    elsif user_permitted_params[:delivery_address].present? && @user_to_validate.update(user_permitted_params)
      flash[:success] = t("user.update.success.delivery_address")
      redirect_back(fallback_location: user_path(@user_to_validate.id))
    else
      flash[:error] = t('error_500.body')
      redirect_to root_path
    end
  end

  private

  def user_permitted_params
    params.require(:user).permit(:is_maker, :delivery_address)
  end

  def load_user
    if current_user.present?
      @user = current_user
    else
      @user = User.new
    end
  end
end
