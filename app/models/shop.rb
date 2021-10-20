class Shop < ApplicationRecord
  include ImageUploader::Attachment(:image)
  include Reusable

  validates :brand, presence: true
  validates :rich_description, no_attachments: true
  validates :email_pro, presence: true, format: { with: /\A[a-z0-9\+\-_\.]+@[a-z\d\-.]+\.[a-z]+\z/i, message: I18n.t("validate.errors.email") }
  validates :website, allow_blank: true, format: { with: /\A^(https?:\/\/)?(www\.)?([a-zA-Z0-9]+(-?[a-zA-Z0-9])*\.)+[\w]{2,}(\/\S*)?$\z/, message: I18n.t("validate.errors.website") }
  validates :terms_of_service, acceptance: { message: I18n.t("validate.errors.terms_of_service") }
  validates :company_id, presence: true, format: { with: /\A\d+\z/, message: I18n.t("validate.errors.must_be_numbers") }, length: { is: 14 }
  validate :forbid_changing_uid, on: :update

  belongs_to :user
  belongs_to :address, optional: true
  has_many :items
  
  has_rich_text :rich_description

  def show_image
    if self.image.present?
      return self.image[:shop].url
    else
      return "logo_transparent.png"
    end
  end

  def can_receive_payments?
    uid? && provider? && access_code? && publishable_key? && refresh_token?
  end

  def siren
    self.company_id.slice(0..8)
  end

  def verify_company_id
		url = "https://api.insee.fr/entreprises/sirene/V3/siren/#{self.siren}"
		response_text = I18n.t("shop.company_id_not_found")

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
				response_text = I18n.t("shop.insee_company_id_found", legal_name: legal_name, day: date.mday.to_s, month: self.translate_month(date.mon), year: date.year.to_s)
			end
		else
			response_text = I18n.t("shop.insee_error")
		end

		return response_text
	end    

  private

  def forbid_changing_uid
    errors.add(:uid, "ne peut pas être modifié") unless (self.uid_was == nil) || !self.uid_changed?
  end
end
