class OrdersController < ApplicationController
  load_and_authorize_resource

  def new
    @order.user = current_user
    @user_address = @order.user.addresses[0]
    @shop = Shop.find(params[:shop_id])

    ordered_items = @order.create_ordered_items(@shop)

    @session = Stripe::Checkout::Session.create(
      payment_method_types: ['card'],
      line_items: @order.add_all_ordered_items_to_stripe_session(ordered_items),
      mode: 'payment',
      payment_intent_data: {
        application_fee_amount: (@order.total_price(ordered_items) * 5).round, #to be change when user.fee is added to User table
        on_behalf_of: @shop.uid,
        transfer_data: {
          destination: @shop.uid,
        },
      },
      success_url: root_url,
      cancel_url: 'https://localhost:3000/cancel',
    )
  end

  def create
    @order.save
  end

end
