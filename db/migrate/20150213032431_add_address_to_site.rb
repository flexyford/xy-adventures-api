class AddAddressToSite < ActiveRecord::Migration
  def change
    add_column :sites, :address, :string
  end
end
