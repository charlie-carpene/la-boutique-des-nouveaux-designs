# Stripe module
module Stripe
 # stripe main class EventHandler
 class EventHandler
   def call(event)
     method = 'handle_' + event.type.tr('.', '_')
     send method, event
   rescue JSON::ParserError => e
     render json: { status: 400, error: 'Invalid payload' }
     Raven.capture_exception(e)
   rescue Stripe::SignatureVerificationError => e
     render json: { status: 400, error: 'Invalid signature' }
     Raven.capture_exception(e)
   end
 end

 def handle_charge_dispute_created(event)
   # your code goes here
   puts '-' * 30
   puts 'ok'
   puts event
   puts '*' *30
   puts params.inspect
   puts '-' * 30
 end
end
