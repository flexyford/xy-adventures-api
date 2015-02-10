class RouteArea < ActiveRecord::Migration
  def change
  create_table :videos do |t|
    t.string :sw_latitude
    t.string :sw_longitude
    t.string :nw_latitude
    t.string :nw_longitude
    t.timestamps
  end
  end
end
