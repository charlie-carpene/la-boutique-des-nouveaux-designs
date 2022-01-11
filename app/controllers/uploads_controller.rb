class UploadsController < ApplicationController

  def s3
    if can? :manage, current_user.shop
      user_id = current_user.id
      ImageUploader.add_metadata :user_id do |io|
        user_id
      end
    
      set_rack_response ImageUploader.presign_response(:cache, request.env)
    else
      head 401
    end
  end

  def xhr
    if can? :manage, current_user.shop
      uploader = set_uploader(params[:uploader_type])
      set_metadata(uploader, params, current_user.id)

      set_rack_response uploader.upload_response(:cache, request.env)
    else
      head 401
    end
  end

  private
 
  def set_rack_response((status, headers, body))
    self.status = status
    self.headers.merge!(headers)
    self.response_body = body
  end

  def set_uploader(type)
    case type
    when 'image'
      return ImageUploader
    when 'picture'
      return PictureUploader
    else
      return 'error'
    end
  end

  def set_metadata(uploader, params, user_id)
    uploader.add_metadata :user_id do |io| user_id end

    if params[:uploader_type] == 'picture'
      uploader.add_metadata :item_id do |io| params[:item_id] end
    end
  end
end
