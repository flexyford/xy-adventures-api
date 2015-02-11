require_relative '../../lib/assets/geo/geocalc'

class RouteArea < ActiveRecord::Base

  def self.build_route_areas route, range

    filter_route(route, range)
    .map do |point|
      point = Route::Calculation.coord_float_to_string(point)
      {
        :area => Route::Calculation.get_SW_NE_coordinates(point, range),
        :range => range,
        :center => point
      }
    end
  end

  def self.filter_route route, range
    prevPoint = route.first

    filteredRoute = route[1 .. route.length].select do |point|
      if (Route::Calculation.distance_between(prevPoint, point, {units: :mi}) >= range)
        prevPoint = point
      else
        false
      end
    end
    # Prepend First Point
    filteredRoute.unshift(route.first)
  end

  def self.exists area
    return true
  end

  def self.isWithinDateRange num_days
    return false
  end


end