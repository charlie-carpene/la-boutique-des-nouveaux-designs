class ApplicationMailer < ActionMailer::Base
  default from: 'from@example.com'
  layout 'mailer'

  def add_attached_files(shop_images)
    content_array = []

    shop_images.each do |shop_image|
      attached_file_content = {
        "ContentType"=> shop_image.content_type,
        "Filename"=> shop_image.original_filename,
        "Base64Content"=> Base64.encode64(File.open(shop_image.tempfile, "rb").read)
      }
      content_array.push(attached_file_content)
    end
    return content_array
  end

  def add_items_to_email(order)
    item = []
    order.order_items.each do |order_item|
      name_and_price = "#{order_item.item.name} (à #{I18n.t("currency_html", price: order_item.item.price)}/unité)"
      item.push(name_and_price)
    end

    return item
  end

  def formatted_address(address)
    hash = {
      'full_name' => "#{address.first_name} #{address.last_name}",
      'address_line_1' => address.address_line_1,
      'code_and_city' => "#{address.zip_code} #{address.city}",
    }

    if address.address_line_2.present?
      hash['address_line_2'] = address.address_line_2
    end

    return hash
  end

  def website_url(slug)
    if Rails.env.production?
      return "https://boutique.nouveauxdesigns.fr/#{slug}"
    elsif Rails.env.development?
      return "http://localhost:3000/#{slug}"
    else
      return "not-in-dev-nor-prod/#{slug}"
    end
  end

  def admin_email
    if Rails.env.production?
      return "atelier@nouveauxdesigns.fr"
    elsif Rails.env.development?
      return "solunacisv@gmail.com"
    elsif Rails.env.test?
      return "error@nouveauxdesigns.fr"
    else
      return "error@nouveauxdesigns.fr"
    end
  end
end
