module TestData
  module_function
  
  def image_data
    attacher = Shrine::Attacher.new
    attacher.set(uploaded_image)
    attacher.column_data # or attacher.data in case of postgres jsonb column 
  end
  
  def uploaded_image
    file = File.open("./spec/fixtures/files/upload_img_test.png", binmode: true)
  
    # for performance we skip metadata extraction and assign test metadata 
    uploaded_file = Shrine.upload(file, :store, metadata: false)
    uploaded_file.metadata.merge!(
      "size"      => File.size(file.path),
      "mime_type" => "image/jpeg",
      "filename"  => "test.jpg",
    )

    uploaded_file
  end
end