class ImageUploader < Shrine
  # plugins and uploading logic
  plugin :store_dimensions
  plugin :determine_mime_type
  plugin :pretty_location
  plugin :remove_invalid
  plugin :validation_helpers
  plugin :processing
  plugin :delete_raw
  plugin :derivatives, versions_compatibility: true

  Attacher.validate do
    validate_mime_type %w[image/jpeg image/png], message: "doit être un jpeg ou un png"
    validate_max_size 3*1024*1024, message: "doit être inférieur à 3 Mo"
    validate_extension_inclusion %w[jpg jpeg png], message: "doit être un jpeg ou un png"
  end

  Attacher.derivatives do |original|
    magick = ImageProcessing::MiniMagick.source(original)
 
    { 
      shop:  magick.resize_to_fill!(200, 200),
    }
  end

  def generate_location(io, context = {})
    extension = ".#{io.extension}" if io.is_a?(UploadedFile) && io.extension
    extension ||= File.extname(extract_filename(io).to_s).downcase
    @filename = context[:derivative].blank? ? 'original' : context[:derivative]
    shopname = context[:record].brand.downcase
    user_id = context[:record].user.id
    directory = context[:record].class.name.downcase.pluralize
    "#{directory}/#{shopname}_user-#{user_id}_#{@filename}#{extension}"
  end
end
