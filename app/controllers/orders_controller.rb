require 'json'

class OrdersController < ApplicationController
  load_and_authorize_resource
  skip_load_resource only: :create
  skip_before_action :verify_authenticity_token, only: [:create]

  def new
    @shop = Shop.find(params[:shop_id])

    #create only order items. No dependent destroy with items nor order. Can be destroy if checkout fails
    ordered_items = @order.create_ordered_items(@shop)

    @session = Stripe::Checkout::Session.create(
      payment_method_types: ['card'],
      client_reference_id: @order.user_id,
      customer_email: @order.user.email, #to be change to customer when stripe customers are created when user create an account on the app.
      line_items: @order.add_all_ordered_items_to_stripe_session(ordered_items),
      mode: 'payment',
      payment_intent_data: {
        #application_fee_amount: (@order.total_price(ordered_items) * 5).round, #to be change when user.fee is added to User table
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
    payload = request.body.read
    puts '#' * 30
    puts payload
    puts '#' * 30
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

    puts '#' * 30
    event = JSON.parse(payload)
    puts event['data']['object']['client_reference_id']
    puts '#' * 30

    if event['type'] == "payment_intent.succeeded"
      session = event['data']['object']
      puts '-' * 30
      puts "payment_intent.succeeded"
      puts '-' * 30
    end

    if event['type'] == "checkout.session.completed"
      puts '*' * 30
      puts "checkout.session.completed"
      puts '*' * 30
    end
    #@order.user = current_user
    #@user_address = @order.user.addresses[0]

  end

end
