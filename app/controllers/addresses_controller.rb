class AddressesController < ApplicationController
  def create
    @user = User.find(current_user.id)
    @address = Address.create(address_permitted_params)
    @user.addresses.push(@address)
    @user.save

    redirect_to user_path(current_user.id)
  end

  def show
    @address = Address.find(params[:id])
  end

  def edit
    @address = Address.find(params[:id])
  end

  def destroy
    Address.destroy(params[:id])
    redirect_to user_path(current_user.id)
  end

  private

  def address_permitted_params
    params.require(:address).permit(:first_name, :last_name)
  end

end
