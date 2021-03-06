class AdminMailer < ApplicationMailer
  default from: 'solunacisv@gmail.com'

  def new_shop_request(user, shop_images)
    Mailjet::Send.create(messages: [{
      'To'=> [{
        'Email'=> 'atelier@nouveauxdesigns.fr',
        'Name'=> 'You'
      }],
      'Variables' => {
        'brand' => user.shop.brand,
        'email_pro' => user.shop.email_pro,
        'url' => edit_user_url(user.id),
      },
      'TemplateID'=> 2222960,
      'TemplateLanguage'=> true,
      'Subject'=> 'Nvlle demande de créateur - la Boutique des Nouveaux Designs',
      'Attachments'=>
      unless shop_images.blank?
        add_attached_files(shop_images) #method in application_mailer.
      end
    }])
  end
end
