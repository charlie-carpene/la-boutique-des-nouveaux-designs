# frozen_string_literal: true

class InputComponent < ViewComponent::Base
  def initialize(id: nil, label: nil, placeholder: nil, value: nil, class_name: "")
    @id = id
    @label = label
    @placeholder = placeholder
    @value = value
    @class = class_name
  end

end
