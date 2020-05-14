class UsersController < ApplicationController
  load_resource :only => :show
  authorize_resource

  def show
  end

  def edit
    @user_to_validate = User.find(params[:id])
    unless load_user.admin.present? #can't use load_resource because it takes the params from the URL and here we want the current_user id
      flash[:error] = "Veuillez vous connecter en tant qu'administrateur pour accéder à cette page."
      redirect_to root_path
    end
  end

  def update
    @user_to_validate = User.find(params[:id])
    @user_to_validate.is_maker = true
    if load_user.admin.present? && @user_to_validate.save
      #UserMailer.new_shop_request_accepted(@user_to_validate).deliver_now
      flash[:success] = "La validation a bien été effectuée et un mail a été envoyé à #{@user_to_validate.shop.email_pro}."
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
