class CreateRouteAreas < ActiveRecord::Migration
  def change
    create_table :route_areas do |t|
      t.float :sw_latitude
      t.float :sw_longitude
      t.float :ne_latitude
      t.float :ne_longitude
      t.timestamps null: false
    end
  end
end
