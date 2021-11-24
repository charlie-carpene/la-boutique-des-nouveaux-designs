class PictureUploader < Shrine
  plugin :store_dimensions
  plugin :determine_mime_type
  plugin :pretty_location
  plugin :remove_invalid
  plugin :validation_helpers
  plugin :processing
  plugin :delete_raw
  plugin :derivatives, versions_compatibility: true
  plugin :default_url

  Attacher.validate do
    validate_mime_type %w[image/jpeg image/png], message: "doit être un jpeg ou un png"
    validate_max_size 3*1024*1024, message: "doit être inférieur à 3 Mo"
    validate_extension_inclusion %w[jpg jpeg png], message: "doit être un jpeg ou un png"
  end

  Attacher.derivatives do |original|
    magick = ImageProcessing::MiniMagick.source(original)
 
    { 
      card: magick.resize_to_fill!(200, 300),
      cart: magick.resize_to_fill!(100, 100),
      item_show: magick.resize_to_fill!(600, 500),
    }
  end

  Attacher.default_url do |derivative: nil, **|
    file&.url if derivative
  end

  def generate_location(io, context = {})
    extension = ".#{io.extension}" if io.is_a?(UploadedFile) && io.extension
    extension ||= File.extname(extract_filename(io).to_s).downcase
    @filename = File.basename(extract_filename(io).to_s, '.*').downcase.split(/[^a-zA-Z\d:]/).join
    version = context[:derivative].blank? ? 'original' : context[:derivative]
    itemname = context[:record].item.present? === true ? "#{context[:record].item.name.titleize.split(/[\s$&+,:;=?@#|'<>.^*()%!-]/).join}" : ''
    item_id = context[:record].item.present? === true ? context[:record].item.id : ''
    shopname = context[:record].item.present? === true ? "#{context[:record].item.shop.brand}/" : ''
    directory = context[:record].class.name.downcase.pluralize
    "#{directory}/#{shopname}#{itemname}_item-#{item_id}_#{@filename}_#{version}#{extension}"
  end
end
