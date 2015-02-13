class AddCityCountryZipToSites < ActiveRecord::Migration
  def change
    add_column :sites, :city, :string
    add_column :sites, :country, :string
    add_column :sites, :zipcode, :string
  end
end
