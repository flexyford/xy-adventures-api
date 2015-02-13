class CreateTemp < ActiveRecord::Migration
  def change
    create_table :temps do |t|
      t.string  :type
      t.string  :name
      t.float   :price
      t.string  :url
      t.float   :latitude
      t.float   :longitude
      t.json    :meta
      t.string  :city
      t.string  :country
      t.string  :zipcode
      t.string  :address

      t.timestamps null: false
    end
  end
end
