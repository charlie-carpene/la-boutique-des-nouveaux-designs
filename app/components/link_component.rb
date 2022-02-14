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

  def initialize(title: "", link:, html_options: {}, icon: nil)
    @title = title
    @link = link
    @html_options = html_options
    @icon = icon
  end

  def handle_icon
    @title = ICON_MAPPINGS[@icon]
    add_html_options({ class: " #{ICON_CLASS}"})

    if @icon == :delete
      add_html_options(data: { confirm: t("button.delete_.are_you_sure") })
    end
  end

  def add_html_options(hash)
    hash.each do |key, value|
      if key == :class && @html_options[key].present?
        @html_options[key] += value
      else
        @html_options[key] = value
      end
    end

    return @html_options
  end
end
