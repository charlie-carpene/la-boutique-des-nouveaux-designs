# frozen_string_literal: true

class LinkComponent < ViewComponent::Base
  ICON_CLASS = "delete-icon delete-icon-bg".freeze

  ICON_ADD = ActionController::Base.helpers.image_tag("icons/cart_add.svg", class: "color-black-filtered-to-primary filter-to-success card-icon").freeze
  ICON_EDIT = ActionController::Base.helpers.image_tag("icons/edit.svg", class: "color-black-filtered-to-primary filter-to-warning card-icon").freeze
  ICON_DELETE = ActionController::Base.helpers.image_tag("icons/trash.svg", class: "color-black-filtered-to-primary filter-to-danger card-icon").freeze

  ICON_MAPPINGS = {
    add: ICON_ADD,
    edit: ICON_EDIT,
    delete: ICON_DELETE
  }.freeze

  def initialize(title: "", link:, class_name: nil, method: "get", data: {}, icon: false)
    @title = title
    @link = link
    @class = class_name
    @method = method
    @data = data
    @icon = icon
  end

  def handle_icon
    @title = ICON_MAPPINGS[@method]
    @class << " #{ICON_CLASS}"

    if @method == :delete
      @data[:confirm] = t("button.delete_.are_you_sure")
    end
  end
end
