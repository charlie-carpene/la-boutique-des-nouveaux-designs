class OrdersController < ApplicationController
  load_resource

  def new
    @order.user = current_user
    @user_address = @order.user.addresses[0]
    @shop_address = @order.user.cart.items.first.shop
    puts "-" * 30
    puts @order.inspect
    puts @user_address.inspect
    puts @shop_address.inspect
    puts @order.user.cart.items.first.item_pictures.last.picture[:cart].url
    puts "-" * 30

    @product = Stripe::Product.create({
      name: @order.user.cart.items.first.name,
      images: ["http://localhost:300/#{@order.user.cart.items.first.item_pictures.last.picture[:cart].url}"]
    })

    @price = Stripe::Price.create({
      product: @product.id,
      unit_amount: "#{@order.user.cart.items.first.price}" + "00",
      currency: 'eur',
    })

    @session = Stripe::Checkout::Session.create(
      payment_method_types: ['card'],
      line_items: [{
        price: @price.id,
        quantity: 1,
      }],
      mode: 'payment',
      success_url: root_url,
      cancel_url: 'https://localhost:3000/cancel',
    )
  end
end
