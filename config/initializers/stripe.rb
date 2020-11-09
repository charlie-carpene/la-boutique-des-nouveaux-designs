Rails.configuration.stripe = {
  :publishable_key => ENV['PUBLISHABLE_KEY'],
  :secret_key      => ENV['SECRET_KEY'],
  :signing_secret  => ENV['STRIPE_SIGNING_SECRET']
}
Stripe.api_key = Rails.configuration.stripe[:secret_key]
StripeEvent.signing_secret = Rails.configuration.stripe[:signing_secret]

StripeEvent.configure do |events|
 events.subscribe 'charge.dispute.created', Stripe::EventHandler.new
end
