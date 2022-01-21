require "content_disposition"

class PictureUploader < Shrine
  ALLOWED_TYPES = %w[image/jpeg image/png]
  MAX_SIZE = 3*1024*1024

  plugin :store_dimensions
  plugin :determine_mime_type
  plugin :pretty_location
  plugin :remove_invalid
  plugin :validation_helpers
  plugin :processing
  plugin :delete_raw
  plugin :derivatives, versions_compatibility: true
  plugin :upload_endpoint, max_size: MAX_SIZE
  plugin :default_url do |context|
    "img-items/adnd-squarre-0.jpeg"
  end
  plugin :add_metadata
  plugin :presign_endpoint, presign_options: -> (request) do
    filename = request.params["filename"]
    type = request.params["type"]
    {
      content_disposition:    ContentDisposition.inline(filename),
      content_type:           type,
      content_length_range:   0..MAX_SIZE,
    }
  end

  Attacher.validate do
    validate_mime_type ALLOWED_TYPES, message: "doit être un jpeg ou un png"
    validate_max_size MAX_SIZE, message: "doit être inférieur à 3 Mo"
    validate_extension_inclusion %w[jpg jpeg png], message: "doit être un jpeg ou un png"
  end

  Attacher.derivatives do |original|
    magick = ImageProcessing::MiniMagick.source(original)
 
    { 
      card: magick.resize_to_fill!(300, 300),
      cart: magick.resize_to_fill!(100, 100),
      item_show: magick.resize_to_fill!(600, 600),
    }
  end

  Attacher.default_url do |derivative: nil, **|
    file&.url if derivative
  end

  def generate_location(io, record: nil, derivative: nil, metadata: {}, **options)
    extension = ".#{io.extension}" if io.is_a?(UploadedFile) && io.extension
    extension ||= File.extname(extract_filename(io).to_s).downcase
    @filename = File.basename(extract_filename(io).to_s, '.*').downcase.split(/[^a-zA-Z\d:]/).join
    version = derivative.blank? ? 'original' : derivative

    item = record.present? ? Item.find(record.item.id) : nil
    itemname = item.present? ? "#{item.name.titleize.split(/[\s$&+,:;=?@#|'<>.^*()%!-]/).join}" : 'no-name'
    item_id = item.present? ? item.id : 'no-id'
    shopname = item.present? ? "#{item.shop.brand}" : 'no-shop'
    directory = item.present? ? item.item_pictures.first.class.name.downcase.pluralize : 'itempictures'
    "#{directory}/#{shopname}/#{itemname}_item-#{item_id}_#{@filename}_#{version}#{extension}"
  end
end
