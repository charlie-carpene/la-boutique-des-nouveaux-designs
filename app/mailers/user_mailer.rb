class UserMailer < ApplicationMailer
  default from: 'solunacisv@gmail.com'

  def welcome_email(user)
    Mailjet::Send.create(messages: [{
      'From'=> {
        'Email'=> admin_email,
        'Name'=> 'La Boutique des Nouveaux Designs'
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
        'Name'=> 'La Boutique des Nouveaux Designs'
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
      'Subject'=> 'Demande pour devenir créateur',
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
        'Name'=> 'La Boutique des Nouveaux Designs'
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
      'Subject'=> 'Suivi de ta demande pour devenir créateur',
    }])
  end

  def new_shop_request_accepted(user)
    Mailjet::Send.create(messages: [{
      'From'=> {
        'Email'=> admin_email,
        'Name'=> 'La Boutique des Nouveaux Designs'
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
      'Subject'=> 'Suivi de ta demande pour devenir créateur',
    }])
  end

  def new_order_from_customer(order)
    Mailjet::Send.create(messages: [{
      'From'=> {
        'Email'=> admin_email,
        'Name'=> 'La Boutique des Nouveaux Designs'
      },
      'To'=> [{
        'Email'=> order.user.email,
        'Name'=> 'You'
      }],
      'Variables' => {
        'total_price' => order.total_price,
        'brand' => order.shop.brand,
        'shop_email' => order.shop.email_pro,
        'url' => website_url("users/#{order.user.id}/orders")
      },
      'TemplateID'=> 3652313,
      'TemplateLanguage'=> true,
      'Subject'=> 'Merci pour ta commande',
    }])
  end

  def new_order_for_maker(order)
    Mailjet::Send.create(messages: [{
      'From'=> {
        'Email'=> admin_email,
        'Name'=> 'La Boutique des Nouveaux Designs'
      },
      'To'=> [{
        'Email'=> order.shop.email_pro,
        'Name'=> 'You'
      }],
      'Variables' => {
        'total_price' => order.total_price,
        'customer_email' => order.user.email,
        'url' => website_url("order_items"),
        **formatted_address(order.address),
      },
      'TemplateID'=> 3652327,
      'TemplateLanguage'=> true,
      'Subject'=> 'Nouvelle commande',
    }])
  end

  def tracking_id_for_customer(order)
    Mailjet::Send.create(messages: [{
      'From' => {
        'Email' => admin_email,
        'Name' => 'La Boutique des Nouveaux Designs',
      },
      'To' => [{
        'Email' => order.user.email,
        'Name' => 'You',
      }],
      'Variables' => {
        'brand' => order.shop.brand,
        'shop_email' => order.shop.email_pro,
        'tracking_url' => order.tracking_url,
        'url' => website_url("users/#{order.user.id}/orders"),
      },
      'TemplateID'=> 3652463,
      'TemplateLanguage'=> true,
      'Subject'=> 'Suivi de ta commande',
    }])
  end
end
