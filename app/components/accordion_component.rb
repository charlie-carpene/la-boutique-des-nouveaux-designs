# frozen_string_literal: true

class AccordionComponent < ViewComponent::Base
  def initialize(title:, label: nil, overlay: nil)
    @title = title
    @overlay = overlay
    @label = label
  end

end
