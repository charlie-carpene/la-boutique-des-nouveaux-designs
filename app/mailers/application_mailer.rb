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

  def add_articles_to_email(order)
    order_item_names = []
    order.order_items.each do |order_item|
      name_and_price = "#{order_item.item.name} (à #{order_item.item.price}€/unité)"
      order_item_names.push(name_and_price)
    end

    return order_item_names.join(", ")
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
