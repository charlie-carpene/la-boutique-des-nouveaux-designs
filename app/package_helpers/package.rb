class Package
  def initialize
    @is_a_letter = false
    @is_valide = true
    @width = 0
    @height = 0
    @depth = 0
    @weight = 0
    @items_price = 0
    @shipping_price = 0
    @items = []
    @errors = []
  end

  def width
    @width
  end

  def height
    @height
  end

  def depth
    @depth
  end

  def weight
    @weight
  end

  def items_price
    @items_price
  end

  def shipping_price
    @shipping_price
  end

  def is_valide
    @is_valide
  end

  def items
    @items
  end

  def errors
    @errors
  end

  def add_error(message)
    @errors.push(message)
  end

  def get_side_size(side)
    case side
    when :width
      return self.width
    when :height
      return self.height
    when :depth
      return self.depth
    else
      return 'unknown side'
    end
  end

  def set_side_size(side, value, round)
    case side
    when :width
      round < 2 ? @width = value : @width += value
    when :height
      round < 2 ? @height = value : @height += value
    when :depth
      round < 2 ? @depth = value : @depth += value
    else
      return 'unknown side'
    end
  end

  def add_item_price_to_package(item)
    @items_price += item.price
  end

  def add_item_weight_to_package(item)
    @weight += item.weight
  end

  def update_shipping_price_to(shipping_price)
    @shipping_price = shipping_price
  end

  def set_is_valide(value)
    @is_valide = value
  end

  def total_weight(items)
    if items.class == Array
      return items.sum { |item| item.weight }
    else
      return items.total_weight
    end
  end

  def add_item_to_package(item)
    if item_values_present?(item)
      item_lengths = { 
        width: item.width, 
        height: item.height,
        depth: item.depth
      }
      package_lengths = {
        width: self.width,
        height: self.height,
        depth: self.depth
      }

      item_lengths_sorted = item_lengths.sort_by { |k, v| -v }
      package_lengths_sorted = package_lengths.sort_by { |k, v| -v }

      3.times do |index|
        if item_lengths_sorted[index][1] > package_lengths_sorted[index][1] || index >= 2
          self.set_side_size(package_lengths_sorted[index][0], item_lengths_sorted[index][1], index)
        end
      end

      self.add_item_weight_to_package(item)
      self.add_item_price_to_package(item)
      self.save_item_in_package(item)
    else
      self.set_is_valide(false)
      self.add_error(I18n.t("package.values_missing"))
    end
    return self
  end

  def add_all_items_to_package(items)
    if items.respond_to?(:each)
      items.each do |item|
        check_item_type_then_add_it_to_package(item)
      end
    else
      check_item_type_then_add_it_to_package(items)
    end

    self.set_shipping_price

    return self
  end

  def save_item_in_package(item)
    @items.push(item)
  end
  
  def total_price
    return self.shipping_price + self.items_price
  end

  private

  def set_shipping_price
    package_size = [self.width, self.height, self.depth]

    if package_size.sum <= 150 && package_size.max < 100
      weight = self.weight

      case weight
      when 0
        self.add_error(I18n.t("package.weigth_missing"))
      when 1..250
        self.update_shipping_price_to(4.95)
      when 251..500
        self.update_shipping_price_to(6.55)
      when 501..750
        self.update_shipping_price_to(7.45)
      when 751..1000
        self.update_shipping_price_to(8.10)
      when 1001..2000
        self.update_shipping_price_to(9.35)
      when 2001..5000
        self.update_shipping_price_to(14.35)
      when 5001..10000
        self.update_shipping_price_to(20.85)
      when 10001..15000
        self.update_shipping_price_to(26.40)
      when 15000..30000
        self.update_shipping_price_to(32.70)
      else
        self.add_error(I18n.t("package.too_heavy"))
      end
    else
      self.add_error(I18n.t("package.too_big"))
    end

    return self
  end
  
  def check_item_type_then_add_it_to_package(item)
    if item.respond_to?(:qty_ordered)
      item.qty_ordered.times do 
        self.add_item_to_package(item.item)
      end
    elsif item.respond_to?(:item_qty_in_cart)
      item.item_qty_in_cart.times do 
        self.add_item_to_package(item.item)
      end
    else
      self.add_item_to_package(item)
    end
  end

  def item_values_present?(item)
    item.width.present? && item.height.present? && item.depth.present? && item.weight.present?
  end
end
