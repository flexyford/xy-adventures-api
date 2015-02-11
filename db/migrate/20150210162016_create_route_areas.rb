class CreateRouteAreas < ActiveRecord::Migration
  def change
    create_table :route_areas do |t|
      t.string :sw_latitude
      t.string :sw_longitude
      t.string :ne_latitude
      t.string :ne_longitude
      t.timestamps null: false
    end
  end
end
