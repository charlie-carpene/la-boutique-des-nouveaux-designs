class UsersController < ApplicationController
  load_and_authorize_resource

  def show
    puts "-" * 30
    puts "-" * 30
    can? :manage, User
    #  redirect_to root_path
    #end
  end
end
