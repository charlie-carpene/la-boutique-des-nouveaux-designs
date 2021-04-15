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
      order_item_names.push(order_item.item.name)
    end

    return order_item_names.join(", ")
  end
end
