class UserMailer < ApplicationMailer
  default from: 'solunacisv@gmail.com'

  def welcome_email(user)
    Mailjet::Send.create(messages: [{
      'From'=> {
        'Email'=> admin_email,
        'Name'=> 'Boutique des Nouveaux Designs'
      },
      'To'=> [{
        'Email'=> user.email,
        'Name'=> 'You'
      }],
      'Variables' => {
        'url' => website_url("users/sign_in"),
      },
      'TemplateID'=> 2222971,
      'TemplateLanguage'=> true,
      'Subject'=> 'Bienvenue à la Boutique des Nouveaux Designs',
    }])
  end

  def new_shop_request(user, shop_images)
    Mailjet::Send.create(messages: [{
      'From'=> {
        'Email'=> admin_email,
        'Name'=> 'Boutique des Nouveaux Designs'
      },
      'To'=> [{
        'Email'=> user.shop.email_pro,
        'Name'=> 'You'
      }],
      'Variables' => {
        'brand' => user.shop.brand,
        'email_pro' => user.shop.email_pro,
        'url' => website_url("cgv")
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
      'From'=> {
        'Email'=> admin_email,
        'Name'=> 'Boutique des Nouveaux Designs'
      },
      'To'=> [{
        'Email'=> shop.email_pro,
        'Name'=> 'You'
      }],
      'Variables' => {
        'brand' => shop.brand,
        'email_pro' => shop.email_pro,
        'url' => website_url("")
      },
      'TemplateID'=> 2222965,
      'TemplateLanguage'=> true,
      'Subject'=> 'La Boutique des Nouveaux Designs',
    }])
  end

  def new_shop_request_accepted(user)
    Mailjet::Send.create(messages: [{
      'From'=> {
        'Email'=> admin_email,
        'Name'=> 'Boutique des Nouveaux Designs'
      },
      'To'=> [{
        'Email'=> user.shop.email_pro,
        'Name'=> 'You'
      }],
      'Variables' => {
        'brand' => user.shop.brand,
        'email_pro' => user.shop.email_pro,
        'url' => website_url("users/sign_in")
      },
      'TemplateID'=> 2222969,
      'TemplateLanguage'=> true,
      'Subject'=> 'La Boutique des Nouveaux Designs',
    }])
  end

# TemplateID should be changed back in both methods when the beta-test phase is over

  def new_order_customer_email(order)
    Mailjet::Send.create(messages: [{
      'From'=> {
        'Email'=> admin_email,
        'Name'=> 'Boutique des Nouveaux Designs'
      },
      'To'=> [{
        'Email'=> order.user.email,
        'Name'=> 'You'
      }],
      'Variables' => {
        'total_price' => order.total_price,
        'brand' => order.shop.brand,
        'shop_email' => order.shop.email_pro,
        'url' => website_url("users/#{order.user.id}/orders/#{order.id}")
      },
      'TemplateID'=> 2813723,
      'TemplateLanguage'=> true,
      'Subject'=> 'Nouvelle commande - La Boutique des Nouveaux Designs',
    }])
  end

  def new_order_shop_email(order)
    Mailjet::Send.create(messages: [{
      'From'=> {
        'Email'=> admin_email,
        'Name'=> 'Boutique des Nouveaux Designs'
      },
      'To'=> [{
        'Email'=> order.shop.email_pro,
        'Name'=> 'You'
      }],
      'Variables' => {
        'total_price' => order.total_price,
        'customer_email' => order.user.email,
        'url' => website_url("order_items")
      },
      'TemplateID'=> 2813725,
      'TemplateLanguage'=> true,
      'Subject'=> 'Nouvelle commande - La Boutique des Nouveaux Designs',
    }])
  end
end
