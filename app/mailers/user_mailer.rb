class UserMailer < ApplicationMailer
  default from: 'solunacisv@gmail.com'

  def welcome_email(user)
    Mailjet::Send.create(messages: [{
      'From'=> {
        'Email'=> 'atelier@nouveauxdesigns.fr',
        'Name'=> 'l\'AdND'
      },
      'To'=> [{
        'Email'=> user.email,
        'Name'=> 'You'
      }],
      'Variables' => {
        'url' => new_user_session_url,
      },
      'TemplateID'=> 2222971,
      'TemplateLanguage'=> true,
      'Subject'=> 'Bienvenue à la Boutique des Nouveaux Designs',
    }])
  end

  def new_shop_request(user, shop_images)
    Mailjet::Send.create(messages: [{
      'To'=> [{
        'Email'=> user.shop.email_pro,
        'Name'=> 'You'
      }],
      'Variables' => {
        'brand' => user.shop.brand,
        'email_pro' => user.shop.email_pro,
        'url' => cgv_url
      },
      'TemplateID'=> 2222962,
      'TemplateLanguage'=> true,
      'Subject'=> 'La Boutique des Nouveaux Designs',
      'Attachments'=>
      unless shop_images.blank?
        add_attached_files(shop_images) #method in application_mailer.
      end
    }])
  end

  def new_shop_request_denied(shop)
    Mailjet::Send.create(messages: [{
      'To'=> [{
        'Email'=> shop.email_pro,
        'Name'=> 'You'
      }],
      'Variables' => {
        'brand' => shop.brand,
        'email_pro' => shop.email_pro,
        'url' => root_url
      },
      'TemplateID'=> 2222965,
      'TemplateLanguage'=> true,
      'Subject'=> 'La Boutique des Nouveaux Designs',
    }])
  end

  def new_shop_request_accepted(user)
    Mailjet::Send.create(messages: [{
      'To'=> [{
        'Email'=> user.shop.email_pro,
        'Name'=> 'You'
      }],
      'Variables' => {
        'brand' => user.shop.brand,
        'email_pro' => user.shop.email_pro,
        'url' => new_user_session_url
      },
      'TemplateID'=> 2222969,
      'TemplateLanguage'=> true,
      'Subject'=> 'La Boutique des Nouveaux Designs',
    }])
  end

  def new_order_customer_email(order)
    Mailjet::Send.create(messages: [{
      'To'=> [{
        'Email'=> order.user.email,
        'Name'=> 'You'
      }],
      'Variables' => {
        'total_price' => order.total_price,
        'brand' => order.shop.brand,
        'shop_email' => order.shop.email_pro,
        'url' => user_order_url(order.user.id, order.id)
      },
      'TemplateID'=> 2222989,
      'TemplateLanguage'=> true,
      'Subject'=> 'Nouvelle commande - La Boutique des Nouveaux Designs',
    }])
  end

  def new_order_shop_email(order)
    Mailjet::Send.create(messages: [{
      'To'=> [{
        'Email'=> order.shop.email_pro,
        'Name'=> 'You'
      }],
      'Variables' => {
        'total_price' => order.total_price,
        'customer_email' => order.user.email,
        'url' => order_items_url
      },
      'TemplateID'=> 2222973,
      'TemplateLanguage'=> true,
      'Subject'=> 'Nouvelle commande - La Boutique des Nouveaux Designs',
    }])
  end

end
