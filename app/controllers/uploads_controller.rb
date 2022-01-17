class UploadsController < ApplicationController

  def s3
    if can? :manage, current_user.shop
      user_id = current_user.id
      uploader = set_uploader(params[:uploader_type])
      puts "-" * 30
      puts uploader.inspect
      puts "-" * 30
      uploader.add_metadata :user_id do |io| user_id end
    
      set_rack_response uploader.presign_response(:cache, request.env)
    else
      head 401
    end
  end

  def xhr
    puts "` " * 30
    puts params.inspect
    puts "` " * 30
    if can? :manage, current_user.shop
      user_id = current_user.id
      uploader = set_uploader(params[:uploader_type])
      uploader.add_metadata :user_id do |io| user_id end

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
    puts "*" * 30
    puts type
    puts "*" * 30
    case type
    when 'image'
      return ImageUploader
    when 'picture'
      return PictureUploader
    else
      return 'error'
    end
  end
end
