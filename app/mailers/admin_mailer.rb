class AdminMailer < ApplicationMailer
  default from: 'solunacisv@gmail.com'

  def new_shop_request(user, shop_images)
    Mailjet::Send.create(messages: [{
      'To'=> [{
        'Email'=> admin_email,
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

  #Email to notify admin when there is a new order. Just as info to make sure we know when the first order is done!
  
  def new_order_for_admin(order)
    Mailjet::Send.create(messages: [{
      'From'=> {
        'Email'=> admin_email,
        'Name'=> 'Boutique des Nouveaux Designs'
      },
      'To'=> [{
        'Email'=> "solunacisv@gmail.com",
        'Name'=> 'You'
      }],
      'Variables' => {
        'total_price' => order.total_price,
        'customer_email' => order.user.email,
        'shop_email' => order.items.first.shop.email_pro,
        'brand' => order.shop.brand,
        'items' => add_items_to_email(order),
      },
      'TemplateID'=> 3652426,
      'TemplateLanguage'=> true,
      'Subject'=> 'Suivi admin des commandes - La Boutique des Nouveaux Designs',
    }])
  end
end
