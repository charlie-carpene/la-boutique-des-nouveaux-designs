class RemoveDescriptionFromShop < ActiveRecord::Migration[6.1]
  def change
    reversible do |dir|
      dir.up do
        Shop.find_each do |shop|
          shop.rich_description = shop.description
          shop.save
        end
      end

      dir.down do
        Shop.find_each do |shop|
          unless shop.rich_description.body.blank?
            shop.description = shop.rich_description.body.to_plain_text
            shop.save
          end
        end
      end
    end

    remove_column :shops, :description, :text
  end
end
