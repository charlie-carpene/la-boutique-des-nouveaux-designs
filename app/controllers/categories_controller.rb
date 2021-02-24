class CategoriesController < ApplicationController
  load_and_authorize_resource

  def show
    @items = Item.joins(:categories).where(categories: { id: @category.id })
  end
end
