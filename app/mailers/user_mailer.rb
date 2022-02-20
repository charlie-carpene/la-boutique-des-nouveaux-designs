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

  def new_order_from_customer(order)
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
      'TemplateID'=> 3652313,
      'TemplateLanguage'=> true,
      'Subject'=> 'Merci pour ta commande - La Boutique des Nouveaux Designs',
    }])
  end

  def new_order_for_maker(order)
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
        'full_name' => "#{order.address.first_name} #{order.address.last_name}",
        'address_line_2' => order.address.address_line_2,
        'address_line_1' => order.address.address_line_2,
        'code_and_city' => "#{order.address.zip_code} #{order.address.city}",
        'url' => website_url("order_items")
      },
      'TemplateID'=> 3652327,
      'TemplateLanguage'=> true,
      'Subject'=> 'Nouvelle commande - La Boutique des Nouveaux Designs',
    }])
  end

  def tracking_id_for_customer(order)
    Mailjet::Send.create(messages: [{
      'From' => {
        'Email' => admin_email,
        'Name' => 'Boutique des Nouveaux Designs',
      },
      'To' => [{
        'Email' => order.user.mail,
        'Name' => 'You',
      }],
      'Variable' => {
        'brand' => order.shop.brand,
        'shop_email' => order.shop.email_pro,
        'url' => website_url("users/#{order.user.id}/orders/#{order.id}"),
        'tracking_url' => order.tracking_url,
      },
      'TemplateID'=> 3652463,
      'TemplateLanguage'=> true,
      'Subject'=> 'Suivi de ta commande - La Boutique des Nouveaux Designs',
    }])
  end
end
