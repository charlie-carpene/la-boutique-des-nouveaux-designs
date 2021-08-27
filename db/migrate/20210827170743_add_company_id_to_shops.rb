class AddCompanyIdToShops < ActiveRecord::Migration[6.1]
  def change
    add_column :shops, :company_id, :string, default: ''

    reversible do |dir|
      dir.up do
        Shop.find_each do |shop|
          shop.company_id = shop.compagny_id.to_s
          shop.save
        end
      end

      dir.down do
        Shop.find_each do |shop|
          shop.compagny_id = shop.company_id.to_i
          shop.save
        end
      end
    end

    remove_column :shops, :compagny_id, :bigint
  end
end
