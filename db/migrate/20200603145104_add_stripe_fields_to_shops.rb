class AddStripeFieldsToShops < ActiveRecord::Migration[6.0]
  def change
    add_column :shops, :uid, :string
    add_column :shops, :provider, :string
    add_column :shops, :access_code, :string
    add_column :shops, :publishable_key, :string
  end
end
