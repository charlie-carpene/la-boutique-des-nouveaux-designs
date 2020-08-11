class Shops::OmniauthCallbacksController < Devise::OmniauthCallbacksController

  def stripe_connect
    auth_data = request.env["omniauth.auth"]
    @shop = current_user.shop

    if @shop.persisted?
      @shop.provider = auth_data.provider
      @shop.uid = auth_data.uid
      @shop.access_code = auth_data.credentials.token
      @shop.publishable_key = auth_data.info.stripe_publishable_key
      @shop.save
      
      sign_in_and_redirect @shop
      flash[:notice] = 'Votre compte Stripe a bien été créé et est maintenant connecté à votre boutique' if is_navigational_format?
    else
      session["devise.stripe_connect_data"] = request.env["omniauth.auth"]
      redirect_to host_dashboard
    end
  end

  def failure
    flash[:error] = "La configuration Stripe a échoué"
    redirect_to root_path
  end

end
