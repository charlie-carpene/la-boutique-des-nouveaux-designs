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

  def shipping_cost(weight)
    case weight
    when 1..250
      return 4.95
    when 251..500
      return 6.35
    when 501..750
      return 7.25
    when 751..1000
      return 7.95
    when 1001..2000
      return 8.95
    when 2001..5000
      return 13.75
    when 5001..10000
      return 20.05
    when 10001..30000
      return 28.55
    else
      return 0
    end
  end
end
