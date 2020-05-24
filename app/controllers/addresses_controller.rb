class AddressesController < ApplicationController
  load_and_authorize_resource
  skip_load_resource only: :create

  def new
  end

  def create
    @user = User.find(current_user.id)
    @address = Address.new(address_permitted_params)
    @user.addresses.push(@address)
    if @address.save
      if @user.save
        flash[:success] = "L'adresse a bien été ajoutée"
        redirect_to user_path(@user)
      end
    else
      flash[:error] = translate_error_messages(@address.errors)
      redirect_to new_user_address_path(@user.id)
    end
  end

  def show
  end

  def edit
  end

  def update
    @address.assign_attributes(address_permitted_params)

    if @address.save
      flash[:success] = "Les changements ont bien été pris en compte"
      redirect_to user_path(current_user)
    else
      flash[:error] = translate_error_messages(@address.errors)
      redirect_to edit_user_address_path(@address.user.id, @address.id)
    end
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
