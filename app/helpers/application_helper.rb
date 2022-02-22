require './app/package_helpers/package.rb'

module ApplicationHelper
  def returnAllCategories
     Category.all
  end

  def flash_class(level)
    case level
      when 'notice'
        "alert alert-info"
      when 'success'
        "alert alert-success"
      when 'error'
        "alert alert-danger"
      when 'alert'
        "alert alert-danger"
      else
        "alert alert-primary"
    end
  end

  def encrypt_data(data_to_encrypt, assigned_purpose)
    crypt = ActiveSupport::MessageEncryptor.new([ENV['ENCRYPT_KEY']].pack("H*"))
    return crypt.encrypt_and_sign(data_to_encrypt, purpose: assigned_purpose)
  end

  def decrypt_data(data_to_decrypt, assigned_purpose)
    crypt = ActiveSupport::MessageEncryptor.new([ENV['ENCRYPT_KEY']].pack("H*"))
    return crypt.decrypt_and_verify(data_to_decrypt, purpose: assigned_purpose)
  end

  def upload_server
    Rails.configuration.upload_server
  end
  
  def package(items)
    package = Package.new.add_all_items_to_package(items)
    return package
  end
end
