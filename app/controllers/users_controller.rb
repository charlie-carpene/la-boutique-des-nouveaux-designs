class UsersController < ApplicationController
  load_and_authorize_resource

  def show
    can? :manage, User
  end
end
