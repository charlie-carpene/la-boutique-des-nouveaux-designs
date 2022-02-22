class AddressesController < ApplicationController
  load_and_authorize_resource :user
  load_and_authorize_resource :address, :through => :user
  skip_load_and_authorize_resource :address, only: :create

  def new
  end

  def create
    @address = Address.new(address_permitted_params)
    @address.user = User.find(params[:user_id])
    if @address.save
      flash[:success] = t("address.success.created")
      redirect_to user_path(@address.user), status: :see_other
    else
      flash[:error] = translate_error_messages(@address.errors)
      redirect_to new_user_address_path(params[:user_id])
    end
  end

  def show
  end

  def edit
  end

  def update
    @address.assign_attributes(address_permitted_params)

    if @address.save
      flash[:success] = t("address.success.updated")
      redirect_to user_path(current_user), status: :see_other
    else
      flash[:error] = translate_error_messages(@address.errors)
      redirect_to edit_user_address_path(@address.user.id, @address.id)
    end
  end

  def destroy
    Address.destroy(params[:id])
    flash[:info] = t("address.deleted")
    redirect_back(fallback_location: user_path(current_user), status: :see_other)
  end

  private

  def address_permitted_params
    params.require(:address).permit(:first_name, :last_name, :address_line_1, :address_line_2, :zip_code, :city)
  end

end
