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
      'TemplateID'=> 1378192,
      'TemplateLanguage'=> true,
      'Subject'=> 'Bienvenue à la Boutique des Nouveaux Designs',
    }])
  end

  def new_shop_request(user)
    Mailjet::Send.create(messages: [{
      'To'=> [{
        'Email'=> user.email,
        'Name'=> 'You'
      }],
      'Variables' => {
        'brand' => user.shop.brand,
        'email_pro' => user.shop.email_pro,
        'url' => become_maker_url
      },
      'TemplateID'=> 1383918,
      'TemplateLanguage'=> true,
      'Subject'=> 'La Boutique des Nouveaux Designs',
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
      'TemplateID'=> 1384088,
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
      'TemplateID'=> 1384094,
      'TemplateLanguage'=> true,
      'Subject'=> 'La Boutique des Nouveaux Designs',
    }])
  end

end
