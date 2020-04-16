class AddressesController < ApplicationController
  def new
  end

  def create
    @user = User.find(current_user.id)
    @address = Address.new(address_permitted_params)
    @user.addresses.push(@address)
    if @address.save
      if @user.save
        flash[:success] = "L'adresse a bien ajouté"
        redirect_to user_path(@user)
      end
    else
      flash.now[:error] = translate_error_messages(@address.errors)
      render new_address_path
    end
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
    params.require(:address).permit(:first_name, :last_name, :address_line_1, :address_line_2, :zip_code, :city)
  end

end
