# frozen_string_literal: true

class LinkComponent < ViewComponent::Base

  ICON_MAPPINGS = {
    add: ["cart_add", "filter-to-success"],
    edit: ["edit", "filter-to-warning"],
    delete: ["trash", "filter-to-danger"],
    plus: ["plus", "filter-to-success"],
    minus: ["minus", "filter-to-warning"]
  }.freeze

  def initialize(title: "", link:, html_options: {}, icon: nil, render: true)
    @title = title
    @link = link
    @html_options = html_options
    @icon = icon
    @render = render
  end

  def handle_icon
    @icon_type = ICON_MAPPINGS[@icon][0]
    @icon_class = ICON_MAPPINGS[@icon][1]

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

  def render?
    @render
  end
end
