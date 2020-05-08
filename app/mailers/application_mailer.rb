class ApplicationMailer < ActionMailer::Base
  default from: 'from@example.com'
  layout 'mailer'

  def add_attached_file(user)
    'Attachments'=> [
      user.shop.shop_images.each do |i|
        {
          'ContentType'=> "#{user.shop.shop_images[i].image.metadata['mime_type']}",
          'Filename'=> "#{user.shop.shop_images[i].image.metadata['filename']}",
          'Base64Content'=> "VGhpcyBpcyB5b3VyIGF0dGFjaGVkIGZpbGUhISEK"
        }
      end
    ]
  end
end
