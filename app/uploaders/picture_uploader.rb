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
    validate_mime_type %w[image/jpeg image/png application/pdf], message: "doi(ven)t être un jpeg, un png ou un pdf"
    validate_max_size 3*1024*1024, message: "doi(ven)t être chacun inférieur à 3 Mo"
    validate_extension_inclusion %w[jpg jpeg png pdf], message: "doi(ven)t être un jpeg, un png ou un pdf"
  end

  def generate_location(io, context = {})
    if [:original, nil].include? context[:version]
      @filename = File.basename(extract_filename(io).to_s, '.*')
    end
    extension = ".#{io.extension}" if io.is_a?(UploadedFile) && io.extension
    extension ||= File.extname(extract_filename(io).to_s).downcase
    filename = File.basename(extract_filename(io).to_s, '.*')
    version =  context[:version] === :original ? '' : "_#{context[:version]}"
    directory = context[:record].class.name.downcase.pluralize
    "#{directory}/#{@filename}#{version}#{extension}"
  end

  process(:store) do |io, **options|
    versions = { original: io } # retain original

    io.download do |original|
      pipeline = ImageProcessing::MiniMagick.source(original)

      versions[:card] = pipeline.resize_to_fill!(200, 300)
      versions[:small]  = pipeline.resize_to_limit!(300, 300)
    end

    versions # return the hash of processed files
  end

end
