class ItemPicture < ApplicationRecord
  include PictureUploader::Attachment(:picture)
  belongs_to :item

  validate :create_picture_derivatives, on: [:create, :update], if: :picture_changed?

  private

  def generate_new_picture_location
    puts "-" * 30
    puts "it works"
    puts "-" * 30
    unless self.picture_changed?
      puts "*" * 30
      puts "picture has not changed"
      puts "*" * 30
      attacher = self.picture_attacher
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

  def create_picture_derivatives
    attacher = self.picture_attacher

    if attacher.derivatives.present?
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
    else
      self.picture_derivatives!
    end
  end
end
