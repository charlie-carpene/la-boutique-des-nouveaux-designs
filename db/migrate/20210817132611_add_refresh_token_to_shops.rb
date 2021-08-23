class AddRefreshTokenToShops < ActiveRecord::Migration[6.1]
  def change
    add_column :shops, :refresh_token, :string
  end
end
