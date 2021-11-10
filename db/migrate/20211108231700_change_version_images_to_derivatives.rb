class ChangeVersionImagesToDerivatives < ActiveRecord::Migration[6.1]
  def change
    Shop.find_each do |shop|
      if shop.image.present?
        attacher = self.image_attacher
        old_attacher = attacher.dup
        current_file = old_attacher.file
    
        attacher.set attacher.upload(attacher.file)
        attacher.set_derivatives attacher.upload_derivatives(attacher.derivatives)
  
        begin
          attacher.atomic_persist(current_file)
          old_attacher.destroy_attached
        rescue Shrine::AttachmentChanged,
                ActiveRecord::RecordNotFound
          attacher.destroy_attached
        end
      end
    end
  end
end
