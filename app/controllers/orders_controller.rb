class OrdersController < ApplicationController
  load_and_authorize_resource

  def new
    @order.user = current_user
    @user_address = @order.user.addresses[0]

    ordered_items = @order.create_ordered_items

    @session = Stripe::Checkout::Session.create(
      payment_method_types: ['card'],
      line_items: @order.add_all_ordered_items_to_stripe_session(ordered_items),
      mode: 'payment',
      success_url: root_url,
      cancel_url: 'https://localhost:3000/cancel',
    )
  end

  def create
    @order.save
  end

end
