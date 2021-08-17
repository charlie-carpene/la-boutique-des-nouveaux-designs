class StripeController < ApplicationController
  before_action :check_authenticity_token

  def connect
    if params[:error].present?
      flash[:error] = "La configuration Stripe a échoué. #{params[:error_description]}"
      redirect_to root_path
    else
      response = Faraday.post("https://connect.stripe.com/oauth/token") do |request|
        request.body = {
          client_secret: ENV["SECRET_KEY"],
          code: params[:code],
          grant_type: "authorization_code",
          #refresh_token: "auth_data.credentials.refresh_token",
          #grant_type: "refresh_token"
        }
      end
      parsed_response = JSON.parse(response.env.response_body)

      if parsed_response.key?("error") && current_user.present?
        flash[:error] = "La configuration Stripe a échoué. #{parsed_response["error_description"]}"
        redirect_to root_path
      else
        @shop = current_user.shop
        if @shop.persisted?
          @shop.provider = "stripe_connect"
          @shop.uid = parsed_response["stripe_user_id"]
          @shop.access_code = helpers.encrypt_data(parsed_response["access_token"], "shop_credential")
          @shop.publishable_key = helpers.encrypt_data(parsed_response["stripe_publishable_key"], "shop_credential")
          @shop.refresh_token = helpers.encrypt_data(parsed_response["refresh_token"], "shop_credential")
          @shop.save
          
          redirect_to shop_path(@shop.id)
          flash[:notice] = 'Votre compte Stripe a bien été créé et est maintenant connecté à votre boutique'
        else
          reset_session
          redirect_to host_dashboard
        end
      end
    end
  end

  private

  def check_authenticity_token
    if !params[:state].present?
      flash[:error] = "La requête a échoué car le jeton d'identification n'a pas été trouvé"
      redirect_to root_path
    elsif !valid_authenticity_token?(session, params[:state].split(' ').join('+'))
      flash[:error] = "La requête a été bloquée car le jeton d'identification n'a pas été reconnu"
      redirect_to root_path
    end
  end

end
