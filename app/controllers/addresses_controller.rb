class AddressesController < ApplicationController
  load_and_authorize_resource

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
      flash.now[:error] = translate_error_messages(@address.errors)
      render new_address_path
    end
  end

  def show
    can? :manage, Address
  end

  def edit
    can? :manage, Address
  end

  def update
    can? :manage, Address
    @address.assign_attributes(address_permitted_params)

    if @address.save
      flash[:success] = "Les changements ont bien été pris en compte"
      redirect_to user_path(current_user)
    else
      flash[:error] = translate_error_messages(@address.errors)
      redirect_to edit_address_path(@address.id)
    end
  end

  def destroy
    Address.destroy(params[:id])
    redirect_to user_path(current_user.id)
  end

  private

  def address_permitted_params
    puts "-" * 30
    puts "ok"
    puts "-" * 30

    params.require(:address).permit(:first_name, :last_name, :address_line_1, :address_line_2, :zip_code, :city)
  end

end
