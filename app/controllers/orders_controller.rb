require 'json'

class OrdersController < ApplicationController
  load_and_authorize_resource :user, only: [:index, :show]
  load_and_authorize_resource :order, only: [:new, :show]

  skip_before_action :verify_authenticity_token, only: [:create]

  def new
    @shop = Shop.find(params[:shop_id])

    #create only order items. No dependent destroy with items nor order. Can be destroy if checkout fails
    @ordered_cart_items = @order.find_ordered_items_in_cart(@shop)

    if @ordered_cart_items[0] == 0 #check order.find_ordered_items_in_cart method
      @ordered_cart_items[1].destroy
      flash[:error] = t("order.errors.item_no_longer_available", item_name: @ordered_cart_items[1].item.name)
      redirect_back(fallback_location: root_path)
    elsif @ordered_cart_items[0] == 1
      flash[:error] = t("order.errors.item_available_qty_too_low", item_name: @ordered_cart_items[1].item.name, qty_available: @ordered_cart_items[1].item.available_qty)
      redirect_back(fallback_location: root_path)
    else
      @session = Stripe::Checkout::Session.create(
        payment_method_types: ['card'],
        customer_email: @order.user.email, #to be change to customer when stripe customers are created when user create an account on the app.
        metadata: {
          customer: @order.user_id,
          shop: @shop.id,
        },
        line_items: @order.add_all_ordered_items_to_stripe_session(@ordered_cart_items),
        mode: 'payment',
        payment_intent_data: {
          #application_fee_amount: (@order.total_price_for_new_order(@ordered_cart_items) * 2.9 + 25).round, #to be change when user.fee is added to User table
          on_behalf_of: @shop.uid,
          transfer_data: {
            destination: @shop.uid,
          },
        },
        success_url: root_url + "stripe_fallback?status=success",
        cancel_url: root_url + "stripe_fallback?status=cancel",
      )
    end
  end

  def create
    payload = request.body.read
    event = nil
    sig_header = request.env['HTTP_STRIPE_SIGNATURE']
    # Verify webhook signature and extract the event
    # See https://stripe.com/docs/webhooks/signatures for more information.
    begin
      event = Stripe::Webhook.construct_event(
        payload, sig_header, ENV['STRIPE_SIGNING_SECRET']
      )

    rescue JSON::ParserError => e
      # Invalid payload
      render status: 400, json: e.to_json
    rescue Stripe::SignatureVerificationError => e
      # Invalid signature
      render status: 400, json: e.to_json
    rescue ActionController::InvalidAuthenticityToken => e
      # Invalid AuthenticityToken (which should be avoid using Stripe Post)
      render status: 400, json: e.to_json
    end

    event = JSON.parse(payload)

    if event['type'] == "checkout.session.completed"
      @user = User.find(event['data']['object']['metadata']['customer'])
      @shop = Shop.find(event['data']['object']['metadata']['shop'])
      @order = Order.new(user: @user)

      if @order.save
        @order.create_ordered_items(@shop)
        head 200
      else
        flash[:error] = translate_error_messages(@order.errors)
        #add slack notif for admins
        head 400
      end
    end
  end

  def show
  end

  def index
    @orders = @user.orders.sort_by { |order| [order.created_at] }.reverse
  end

end
