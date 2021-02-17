class StaticPagesController < ApplicationController

  def index
    @items = Item.all.sample(3)
  end

  def become_maker
  end

  def cgv
  end

  def stripe_fallback
    @status = params["status"]

    unless @status == "success" || @status == "cancel"
      flash['error'] = "'#{@status}' n\'est pas un status reconnu par l'application. Veuillez vérifier votre achat et nous contacter si besoin."
      redirect_to root_path
    end
  end
end
