# frozen_string_literal: true
require './app/package_helpers/package.rb'

class DisplayPriceComponent < ViewComponent::Base
  def initialize(items:)
    @items = items
    @package = package(@items)
  end

  def package(items)
    return Package.new.add_all_items_to_package(items)
  end
end
