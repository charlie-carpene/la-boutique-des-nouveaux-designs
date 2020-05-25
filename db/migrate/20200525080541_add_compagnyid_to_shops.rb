class AddCompagnyidToShops < ActiveRecord::Migration[6.0]
  def change
    add_column :shops, :compagny_id, :bigint
  end
end
