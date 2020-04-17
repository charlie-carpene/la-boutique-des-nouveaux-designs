class ApplicationController < ActionController::Base

  private

  rescue_from CanCan::AccessDenied do |exception|
    flash[:error] = 'Vous n\'êtes pas autorisé(e) à faire cette action. '
    redirect_to root_path
  end

  def translate_error_messages(errors)
    full_translated_message = Array.new
    errors.each do |attr, value|
      full_translated_message.push(t(attr) + " " + value)
    end
    return full_translated_message
  end

end
