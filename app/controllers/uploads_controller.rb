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
      user_id = current_user.id
      ImageUploader.add_metadata :user_id do |io|
        user_id
      end

      set_rack_response ImageUploader.upload_response(:cache, request.env)
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
end
