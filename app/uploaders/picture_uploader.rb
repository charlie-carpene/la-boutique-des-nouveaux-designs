class PictureUploader < Shrine
  # plugins and uploading logic
  plugin :store_dimensions
  plugin :determine_mime_type
  plugin :pretty_location
  plugin :remove_invalid
  plugin :validation_helpers
  plugin :versions
  plugin :processing
  plugin :delete_raw

  Attacher.validate do
    validate_mime_type %w[image/jpeg image/png], message: "doit être un jpeg ou un png"
    validate_max_size 3*1024*1024, message: "doit être inférieur à 3 Mo"
    validate_extension_inclusion %w[jpg jpeg png], message: "doit être un jpeg ou un png"
  end

  def generate_location(io, context = {})
    if [:original, nil].include? context[:version]
      @filename = File.basename(extract_filename(io).to_s, '.*')
    end
    extension = ".#{io.extension}" if io.is_a?(UploadedFile) && io.extension
    extension ||= File.extname(extract_filename(io).to_s).downcase
    filename = File.basename(extract_filename(io).to_s, '.*')
    version =  context[:version] === :original ? '' : "_#{context[:version]}"
    itemname = context[:record].item.present? === true ? "#{context[:record].item.name}_" : ''
    shopname = context[:record].item.present? === true ? "#{context[:record].item.shop.brand}/" : ''
    directory = context[:record].class.name.downcase.pluralize
    "#{directory}/#{shopname}#{itemname}#{@filename}#{version}#{extension}"
  end

  process(:store) do |io, **options|
    versions = { original: io } # retain original

    io.download do |original|
      pipeline = ImageProcessing::MiniMagick.source(original)

      versions[:card] = pipeline.resize_to_fill!(200, 300)
      versions[:cart] = pipeline.resize_to_fill!(100, 100)
      versions[:item_show]  = pipeline.resize_to_fill!(600, 500)
    end

    versions # return the hash of processed files
  end

end
