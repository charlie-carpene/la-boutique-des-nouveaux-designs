class Shops::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  before_action :check_authenticity_token

  def stripe_connect
    auth_data = request.env["omniauth.auth"]
    puts "*" * 30
    puts auth_data.credentials.inspect
    puts "*" * 30

    response = Faraday.post("https://connect.stripe.com/oauth/token") do |request|
      request.body = {
        client_secret: ENV["SECRET_KEY"],
        #code: params[:code],
        refresh_token: auth_data.credentials.refresh_token,
        grant_type: "refresh_token"
      }
    end

    puts "-" * 30
    puts JSON.parse(response.env.response_body)["stripe_user_id"]
    puts "-" * 30

    #connected_account_id = response.stripe_user_id

    @shop = current_user.shop

    #if @shop.persisted?
    #  @shop.provider = auth_data.provider
    #  @shop.uid = auth_data.uid
    #  @shop.access_code = helpers.encrypt_data(auth_data.credentials.token, "shop_credential")
    #  @shop.publishable_key = helpers.encrypt_data(auth_data.info.stripe_publishable_key, "shop_credential")
    #  @shop.save
    #  
    #  sign_in_and_redirect @shop
    #  flash[:notice] = 'Votre compte Stripe a bien été créé et est maintenant connecté à votre boutique' if is_navigational_format?
    #else
    #  session["devise.stripe_connect_data"] = request.env["omniauth.auth"]
    #  redirect_to host_dashboard
    #end
  end

  def failure
    flash[:error] = "La configuration Stripe a échoué"
    redirect_to root_path
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
