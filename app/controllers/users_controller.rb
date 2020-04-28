class UsersController < ApplicationController
  load_and_authorize_resource

  def show
  end

  def edit
  end

  def update
    @user.is_maker = true
    if @user.save
      UserMailer.new_shop_request_accepted(@user).deliver_now
      flash[:success] = "La validation a bien été effectuée et un mail a été envoyé à #{@user.shop.email_pro}."
      redirect_to root_path
    else
      flash[:error] = translate_error_messages(@user.shop.errors)
      redirect_to root_path
    end
  end
end
