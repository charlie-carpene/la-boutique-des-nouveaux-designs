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
        'url' => website_url("users/#{user.id}/edit"),
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

# Email during the beta-test phase

  def beta_new_order(order)
    Mailjet::Send.create(messages: [{
      'To'=> [{
        'Email'=> 'atelier@nouveauxdesigns.fr',
        'Name'=> 'You'
      }],
      'Variables' => {
        'customer_email' => order.user.email,
        'brand' => order.items.first.shop.brand,
        'total_price' => order.total_price,
        'articles' => add_articles_to_email(order),
      },
      'TemplateID'=> 2813727,
      'TemplateLanguage'=> true,
      'Subject'=> 'Nvlle commande Click & Collect - la Boutique des Nouveaux Designs',
    }])
  end
end
