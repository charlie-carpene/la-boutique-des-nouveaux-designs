class StaticPagesController < ApplicationController

  def index
    @items = Item.where.not(available_qty: 0).sample(4)
    @categories = Category.all
  end

  def become_maker
  end

  def cgv
  end

  def stripe_fallback
    @status = params["status"]

    unless @status == "success" || @status == "cancel"
      flash['error'] = t("stripe.errors.fallback_status", status: @status)
      redirect_to root_path
    end
  end
end
