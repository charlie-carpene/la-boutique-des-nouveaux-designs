class ApplicationMailer < ActionMailer::Base
  default from: 'from@example.com'
  layout 'mailer'

  def add_attached_files(user)
    content_array = []

    user.shop.shop_images.each_with_index do |content, index|
      content = {
        "ContentType"=> user.shop.shop_images[index].image.metadata["mime_type"],
        "Filename"=> user.shop.shop_images[index].image.metadata["filename"],
        "Base64Content"=> Base64.encode64(open(user.shop.shop_images[index].image) { |io| io.read })
      }
      content_array.push(content)
    end
    return content_array.join(", ")
  end

end
