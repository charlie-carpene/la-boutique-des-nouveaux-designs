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

  def stripe_url
    "https://connect.stripe.com/oauth/authorize?response_type=code&client_id=#{ENV['CLIENT_ID']}&scope=read_write"
  end

end
