# frozen_string_literal: true

class ButtonComponent < ViewComponent::Base
  CLASS_MAPPING = {
    success: "btn btn-success ",
    info: "btn btn-info ",
    warning: "btn button-warning ",
    danger: "btn button-danger ",
  }

  HTML_OPTIONS = { 
    class: "btn btn-success"
  }

  def initialize(id: nil, title:, link:, class_type: :success, html_options: {}, disable: false, disable_text: t("button.disable"))
    @id = id
    @title = title
    @link = link
    @class_type = class_type
    @html_options = init_html_options(html_options)
    @disable = disable
    @disable_text = disable_text
  end

  def init_html_options(html_options)
    hash = { class: CLASS_MAPPING[@class_type] }

    html_options.each do |key, value|
      if key == :class && hash[key].present?
        hash[key] += value
      else
        hash[key] = value
      end
    end

    return hash
  end
end
