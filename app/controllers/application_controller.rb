class ApplicationController < ActionController::Base
  helper_method :translate_error_messages
  
  private

  rescue_from CanCan::AccessDenied do |exception|
    flash[:error] = t("ability.errors.action_not_allowed")
    redirect_to root_path
  end

  def translate_error_messages(errors)
    full_translated_message = Array.new
    errors.each do |error|
      attribute = error.attribute
      message = error.message
      full_translated_message.push(t(attribute) + " " + message)
    end
    return full_translated_message
  end

end
