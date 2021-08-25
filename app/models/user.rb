class User < ApplicationRecord
  after_create :create_cart
  #after_create :welcome_send

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :addresses
  has_one :cart, dependent: :destroy
  has_one :shop
  has_one :admin
  has_many :orders

  def verify_compagny_id
    url = "https://api.insee.fr/entreprises/sirene/V3/siren/#{self.shop.siren}"
    response_text = "ce numéro n'existe pas dans les registres de l'INSEE"

    request_token = Faraday.post("https://api.insee.fr/token") do |request|
      request.headers["Authorization"] = "Basic " + ENV['INSEE_KEY']
      request.headers["Content-Type"] = "application/x-www-form-urlencoded"
      request.body = {
        grant_type: "client_credentials",
        validity_period: "60",
      }
    end

    if request_token.status == 200
      req_token_response = JSON.parse(request_token.body)
      token = req_token_response["access_token"]
      type = req_token_response["token_type"]

      connect_to_insee = Faraday.get(url) do |request|
        request.headers['Authorization'] = type + " " + token
      end

      if connect_to_insee.status == 200
        response = JSON.parse(connect_to_insee.body)
        legal_name = response["uniteLegale"]["periodesUniteLegale"][0]["denominationUniteLegale"].present? ? response["uniteLegale"]["periodesUniteLegale"][0]["denominationUniteLegale"] : response["uniteLegale"]["periodesUniteLegale"][0]["nomUniteLegale"]
        registration_date = response["uniteLegale"]["periodesUniteLegale"][0]["dateDebut"]
        date = Date.parse(registration_date)
        response_text = "enregistré à l'INSEE sous le nom " + legal_name + " depuis le " + date.mday.to_s + " " + ApplicationController.helpers.translate_month(date.mon) + " " + date.year.to_s
      end
    else
      response_text = "erreur de connexion au site de l'INSEE"
    end

    return response_text
  end

  private

  def welcome_send
    UserMailer.welcome_email(self).deliver_now
  end

  def create_cart
    Cart.create(user: self)
  end
end
