class CategoriesController < ApplicationController
  load_and_authorize_resource

  def show
    @items = Item.where(category: @category.id)
  end
end
