class ItemsController < ApplicationController
  load_and_authorize_resource
  skip_load_resource only: :create

  def new
  end

  def create
    # if needed, check again https://github.com/shrinerb/shrine/blob/master/doc/multiple_files.md#4a-form-upload
    @item = Item.new(get_item_permitted_attributes)
    if @item.valid?
      @item.save
      flash[:success] = t("item.success.created")
      redirect_to shop_path(@item.shop_id)
    else
      flash[:error] = translate_error_messages(@item.errors)
      render 'new'
    end
  end

  def show
  end

  def edit
  end

  def update
    puts '*' * 30
    puts params.inspect
    puts '*' * 30

    if params[:files].present? || params[:item][:item_pictures_attributes].present?
      @item.item_pictures.destroy_all
    end

    if @item.update(get_item_permitted_attributes)
      flash[:success] = t("item.success.updated", item_name: @item.name)
      redirect_to item_path(@item.id)
    else
      flash.now[:error] = translate_error_messages(@item.errors)
      render 'edit'
    end
  end

  def destroy
    unless @item.orders.blank?
      flash[:error] = t("item.errors.has_already_been_sold_once")
      redirect_back(fallback_location: root_path)
    else
      @item.destroy
      flash[:error] = t("item.errors.deleted")
      redirect_back(fallback_location: root_path)
    end
  end

  private

  def item_permitted_params
    params.require(:item).permit(:name, :rich_description, :price, :available_qty, :product_weight, :shop_id, item_pictures_attributes: {}, category_ids: [])
  end

  def get_item_permitted_attributes
    if params[:files].present?
      new_item_pictures_attributes = params[:files].inject({}) do |hash, file|
        hash.merge!(SecureRandom.hex => { picture: file })
      end
      item_pictures_attributes = item_permitted_params[:item_pictures_attributes].to_h.merge(new_item_pictures_attributes)
      return item_permitted_params.merge(item_pictures_attributes: item_pictures_attributes)
    else
      return item_permitted_params
    end
  end
end
