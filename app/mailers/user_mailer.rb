class UserMailer < ApplicationMailer
  default from: 'solunacisv@gmail.com'

  def welcome_email(user)
    @user = user
    @url  = 'https://boutique-des-nouveaux-designs.herokuapp.com/users/sign_in'

    Mailjet::Send.create(messages: [{
      'From'=> {
        'Email'=> 'solunacisv@gmail.com',
        'Name'=> 'l\'AdND'
      },
      'To'=> [{
        'Email'=> @user.email,
        'Name'=> 'You'
      }],
      'Variables' => {
        'url' => @url
      },
      'TemplateID'=> 1378192,
      'TemplateLanguage'=> true,
      'Subject'=> 'Bienvenue à la Boutique des Nouveaux Designs',
    }])
  end

end
