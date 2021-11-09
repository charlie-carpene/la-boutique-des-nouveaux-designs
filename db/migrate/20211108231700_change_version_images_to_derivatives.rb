class ChangeVersionImagesToDerivatives < ActiveRecord::Migration[6.1]
  def change
    Shop.find_each do |shop|
      if shop.image.present?
        attacher = shop.image_attacher

        next unless attacher.stored?

        old_derivatives = attacher.derivatives
        attacher.set_derivatives({})
        attacher.create_derivatives
       
        begin
          attacher.atomic_persist
          attacher.delete_derivatives(old_derivatives)
        rescue Shrine::AttachmentChanged,
               ActiveRecord::RecordNotFound
          attacher.delete_derivatives
        end
      end
    end
  end
end
