class CreateAirbnbs < ActiveRecord::Migration
  def change
    create_table "airbnbs"  do |t|
      t.string   "name"
      t.float    "price"
      t.string   "location"
      t.integer  "user_id"
      t.integer  "room_id"
      t.string   "type"
      t.string   "url"
      t.string   "imgUrl"
      t.string   "room_type"
      t.string   "latitude"
      t.string   "longitude" 
      t.timestamps
    end
  end
end
