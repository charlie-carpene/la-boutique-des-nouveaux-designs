class User < ApplicationRecord
  after_create :create_cart
  after_create :welcome_send

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

    connect_to_insee = Faraday.get(url) do |request|
      request.headers['Authorization'] = 'Bearer ' + ENV['INSEE_BEARER_TOKEN']
    end

    if connect_to_insee.status == 200
      response = JSON.parse(connect_to_insee.body)
      legal_name = response["uniteLegale"]["periodesUniteLegale"][0]["denominationUniteLegale"].present? ? response["uniteLegale"]["periodesUniteLegale"][0]["denominationUniteLegale"] : response["uniteLegale"]["periodesUniteLegale"][0]["nomUniteLegale"]
      registration_date = response["uniteLegale"]["periodesUniteLegale"][0]["dateDebut"]
      date = Date.parse(registration_date)
      response_text = "enregistré à l'INSEE sous le nom " + legal_name + " depuis le " + date.mday.to_s + " " + ApplicationController.helpers.translate_month(date.mon) + " " + date.year.to_s
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
