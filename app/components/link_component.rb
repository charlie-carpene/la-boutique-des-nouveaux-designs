# frozen_string_literal: true

class LinkComponent < ViewComponent::Base
  def initialize(title: "", link:, class_name: nil, method: "get", data: {}, icon: false)
    @title = title
    @link = link
    @class = class_name
    @method = method
    @data = data
    @icon = icon
  end

  def handle_icon_class
    if @icon
      case @method
        when "get"
          @class
        when "delete"
          @data[:confirm] = t("button.delete_.are_you_sure")
          @class += " delete-icon fas fa-trash color-change-to-danger"
        else 
          @class
      end
    else
      @class
    end
  end
end
