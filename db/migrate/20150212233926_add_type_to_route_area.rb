class AddTypeToRouteArea < ActiveRecord::Migration
  def change
    add_column :route_areas, :type, :string
  end
end
