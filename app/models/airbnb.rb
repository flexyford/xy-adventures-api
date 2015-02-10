require 'ensnare_bnb'
require_relative '../../lib/assets/geo/geocalc'

class Airbnb < ActiveRecord::Base

  SW = 0
  NE = 1

  def self.retrieve_all_sites route

    @route = JSON.parse(route) # <= Passed by MapBox JS Frontend
    @range = 25

    @@allRooms = []

    # @route = [ [30.250130000000002, -97.74995000000001], [31.12553, -97.33818000000001], [31.636650000000003, -97.09597000000001], [31.64316, -97.09656000000001], [32.40263, -96.87293000000001] ]

    prevPoint = @route.first

    filteredRoute = []
    filteredRoute = @route[1 .. @route.length].select do |point|
      if (Route::Calculation.distance_between(prevPoint, point, {units: :mi}) >= @range)
        prevPoint = point
        true
      else
        false
      end
    end

    # puts filteredRoute
    filteredRoute.unshift(@route.first)

    # point = [LAT, LNG]
    routeAreas = filteredRoute.map do |point|
      point = Route::Calculation.coord_float_to_string(point)
      Route::Calculation.get_SW_NE_coordinates(point, @range)
    end

    @allRoomIds = {}
    th = []
    # routeAreas = [
    #   [SW,NE]
    # ]
    routeAreas.each_index do |idx|
      area = routeAreas[idx]
      th[idx] = Thread.new {
        area[SW] = Route::Calculation.coord_float_to_string(area[SW])
        area[NE] = Route::Calculation.coord_float_to_string(area[NE])
        EnsnareBnb.find_airbnb_hosts(sw: area[SW], ne: area[NE]).each do |room|
          if (!@allRoomIds.has_key?(room[:id])) # Guearantee Unique
            # Check that it falls in the correct range . . .
            lat_upper_bound = area[NE][0].to_f
            lat_lower_bound = area[SW][0].to_f
            lng_upper_bound = area[NE][1].to_f
            lng_lower_bound = area[SW][1].to_f
            if (lat_upper_bound >= room[:latitude].to_f &&  lat_lower_bound <= room[:latitude].to_f &&
                lng_upper_bound >= room[:longitude].to_f && lng_lower_bound <= room[:longitude].to_f)
              @@allRooms.push(room)
              @allRoomIds[room[:id]] = room[:id]
            end 
          end
        end
      }
    end
    th.each {|t| t.join; }

    # @allRooms = [
      # {
      #   lat: 
      #   lng:
      #   id:
      # }
    # ]
    gen_rooms(@@allRooms)
  end

  def self.gen_rooms(rooms)
    rooms.map do |room|  
    {
      room_id: room[:id].to_i,
      name: room[:name],
      price: room[:price].to_f,
      location: room[:location],
      latitude: room[:latitude],
      longitude: room[:longitude],
      url: room[:roomUrl],
      imgUrl: room[:imgUrl]
    }
    end
  end
end
