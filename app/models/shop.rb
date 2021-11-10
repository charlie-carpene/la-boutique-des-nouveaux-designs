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
  validate :create_image_derivatives, on: [:create, :update], if: :image_changed?
  validate :generate_new_image_location, on: :update, if: :brand_changed?, unless: :image_changed?

  belongs_to :user
  belongs_to :address, optional: true
  has_many :items
  
  has_rich_text :rich_description

  def show_image
    if self.image.present?
      return self.image_url(:shop)
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

  def generate_new_image_location
    attacher = self.image_attacher
    old_attacher = attacher.dup
    current_file = old_attacher.file

    if self.brand_changed?
      attacher.set attacher.upload(attacher.file)
      attacher.set_derivatives attacher.upload_derivatives(attacher.derivatives)

      begin
        attacher.atomic_persist(current_file)
        old_attacher.destroy_attached
      rescue Shrine::AttachmentChanged,
             ActiveRecord::RecordNotFound
        attacher.destroy_attached
      end
    end
  end

  def create_image_derivatives
    attacher = self.image_attacher

    if attacher.derivatives.present?
      old_derivatives = attacher.derivatives
      attacher.set_derivatives({})
      attacher.create_derivatives
    
      begin
        attacher.atomic_persist
        attacher.delete_derivatives(old_derivatives)
      rescue Shrine::AttachmentChanged,
            ActiveRecord::RecordNotFound
        attacher.delete_derivatives
      end
    else
      self.image_derivatives!
    end
  end

  def forbid_changing_uid
    errors.add(:uid, "ne peut pas être modifié") unless (self.uid_was == nil) || !self.uid_changed?
  end
end
