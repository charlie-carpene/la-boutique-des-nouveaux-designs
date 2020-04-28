class AdminMailer < ApplicationMailer
  default from: 'solunacisv@gmail.com'

  def new_shop_request(user)
    Mailjet::Send.create(messages: [{
      'To'=> [{
        'Email'=> 'solunacisv@gmail.com',
        'Name'=> 'You'
      }],
      'Variables' => {
        'brand' => user.shop.brand,
        'email_pro' => user.shop.email_pro,
        'url' => edit_user_url(user.id),
      },
      'TemplateID'=> 1383469,
      'TemplateLanguage'=> true,
      'Subject'=> 'Nvlle demande de créateur - la Boutique des Nouveaux Designs',
    }])
  end

end