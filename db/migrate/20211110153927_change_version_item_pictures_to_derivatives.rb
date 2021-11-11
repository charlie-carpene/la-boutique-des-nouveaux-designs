class ChangeVersionItemPicturesToDerivatives < ActiveRecord::Migration[6.1]
  def change
    ItemPicture.find_each do |item_picture|
      if item_picture.picture.present?
        attacher = item_picture.picture_attacher

        next unless attacher.stored?

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
