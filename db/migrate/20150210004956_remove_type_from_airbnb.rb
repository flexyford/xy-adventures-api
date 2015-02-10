class RemoveTypeFromAirbnb < ActiveRecord::Migration
  def change
    remove_column :airbnbs, :type, :string
    remove_column :airbnbs, :room_type, :string
  end
end
