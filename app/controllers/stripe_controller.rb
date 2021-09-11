class StripeController < ApplicationController
  before_action :check_authenticity_token

  def connect
    if params[:error].present?
      flash[:error] = t("stripe.errors.fail_to_connect", error_description: params[:error_description])
      redirect_to root_path
    else
      response = Faraday.post("https://connect.stripe.com/oauth/token") do |request|
        request.body = {
          client_secret: ENV["SECRET_KEY"],
          code: params[:code],
          grant_type: "authorization_code",
        }
      end
      parsed_response = JSON.parse(response.env.response_body)

      if parsed_response.key?("error") && current_user.present?
        flash[:error] = t("stripe.errors.fail_to_connect", error_description: params[:error_description])
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
          flash[:notice] = t("stripe.success.account_connected")
        else
          reset_session
          flash[:error] = t("stripe.errors.fail_to_connect_after_stripe_post")
          redirect_to root_path
        end
      end
    end
  end

  private

  def check_authenticity_token
    if !params[:state].present?
      flash[:error] = t("stripe.errors.csrf_token_not_found")
      redirect_to root_path
    elsif !valid_authenticity_token?(session, params[:state].split(' ').join('+'))
      flash[:error] = t("stripe.errors.csrf_token_dont_match")
      redirect_to root_path
    end
  end
end
