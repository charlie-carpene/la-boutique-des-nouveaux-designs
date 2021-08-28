class UsersController < ApplicationController
  load_resource :only => :show
  authorize_resource

  def show
  end

  def edit
    @user_to_validate = User.find(params[:id])
    @legal_compagny_name = @user_to_validate.shop.verify_company_id

    unless load_user.admin.present? #can't use load_resource because it takes the params from the URL and here we want the current_user id
      flash[:error] = t("errors.admin_required")
      redirect_to root_path
    end
  end

  def update
    @user_to_validate = User.find(params[:id])
    @user_to_validate.is_maker = true
    if load_user.admin.present? && @user_to_validate.save
      UserMailer.new_shop_request_accepted(@user_to_validate).deliver_now
      flash[:success] = t("success.validate_user_as_maker", user_email: @user_to_validate.shop.email_pro)
      redirect_to root_path
    else
      flash[:error] = translate_error_messages(@user_to_validate.shop.errors)
      redirect_to root_path
    end
  end

  private

  def load_user
    if current_user.present?
      @user = current_user
    else
      @user = User.new
    end
  end
end
