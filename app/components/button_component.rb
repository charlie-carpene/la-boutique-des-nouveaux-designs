# frozen_string_literal: true

class ButtonComponent < ViewComponent::Base
  def initialize(id: nil, title:, link:, class_name: "btn-success", data: nil, disable: false, disable_text: t("button.disable"))
    @id = id
    @title = title
    @link = link
    @class = class_name
    @data = data
    @disable = disable
    @disable_text = disable_text
  end
end
