Rails.configuration.stripe = {
  :publishable_key => ENV['PUBLISHABLE_KEY'],
  :secret_key      => ENV['SECRET_KEY'],
  :signing_secret  => ENV['STRIPE_SIGNING_SECRET']
}
Stripe.api_key = Rails.configuration.stripe[:secret_key]
