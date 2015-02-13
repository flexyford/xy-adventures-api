class RemoveTypeFromRouteArea < ActiveRecord::Migration
  def change
    remove_column :route_areas, :type, :string
    add_column :route_areas, :site_type, :string
  end
end
