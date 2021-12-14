require "content_disposition"

class ImageUploader < Shrine
  plugin :store_dimensions
  plugin :determine_mime_type
  plugin :pretty_location
  plugin :remove_invalid
  plugin :validation_helpers
  plugin :processing
  plugin :delete_raw
  plugin :derivatives, versions_compatibility: true
  plugin :upload_endpoint, max_size: 3*1024*1024
  plugin :cached_attachment_data
  plugin :add_metadata
  plugin :upload_endpoint
  plugin :presign_endpoint, presign_options: -> (request) do
    filename = request.params["filename"]
    type = request.params["type"]
    {
      content_disposition:    ContentDisposition.inline(filename),
      content_type:           type,
      content_length_range:   0..(3*1024*1024),
    }
  end
  

  Attacher.validate do
    validate_mime_type %w[image/jpeg image/png], message: "doit être un jpeg ou un png"
    validate_max_size 3*1024*1024, message: "doit être inférieur à 3 Mo"
    validate_extension_inclusion %w[jpg jpeg png], message: "doit être un jpeg ou un png"
  end

  Attacher.derivatives do |original|
    magick = ImageProcessing::MiniMagick.source(original)
 
    { 
      shop: magick.resize_to_fill!(200, 200),
    }
  end
  
  def generate_location(io, record: nil, derivative: nil, metadata: {}, **options)
    puts "-" * 30
    puts io.inspect
    puts '`' * 30
    puts record.inspect
    puts '`' * 30
    puts derivative.inspect
    puts '`' * 30
    puts metadata.inspect
    puts "-" * 30 
    extension = ".#{io.extension}" if io.is_a?(UploadedFile) && io.extension
    extension ||= File.extname(extract_filename(io).to_s).downcase
    @filename = File.basename(extract_filename(io).to_s, '.*').downcase.split(/[^a-zA-Z\d:]/).join
    version = derivative.blank? ? 'original' : derivative

    user = User.find(metadata['user_id'])
    shopname = user.shop.present? ? user.shop.brand.downcase.split.join : 'no-shop'
    
    "shops/#{shopname}_user-#{user.id}_#{@filename}_#{version}_id-#{pretty_location(metadata)}#{extension}"
  end

end
