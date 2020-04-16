class ApplicationController < ActionController::Base

  private

  def translate_error_messages(errors)
    full_translated_message = Array.new
    errors.each do |attr, value|
      full_translated_message.push(t(attr) + " " + value)
    end
    return full_translated_message
  end
  
end
