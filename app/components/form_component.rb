# frozen_string_literal: true

class FormComponent < ViewComponent::Base
  def initialize(path:, method: :post, submit_button: "", class_name: "")
    @path = path
    @method = method
    @submit_button = submit_button
    @class = class_name
  end

end
