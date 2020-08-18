class StaticPagesController < ApplicationController

  def index
    @items = Item.all.sample(3)
  end

  def become_maker
  end
end
