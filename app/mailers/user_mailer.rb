class UserMailer < ApplicationMailer
  default from: 'solunacisv@gmail.com'

  def welcome_email(user)
    @user = user
    @url  = 'https://boutique-des-nouveaux-designs.herokuapp.com/users/sign_in' 

    # c'est cet appel à mail() qui permet d'envoyer l’e-mail en définissant destinataire et sujet.
    mail(to: @user.email, subject: 'Bienvenue chez nous !')
  end
end
