require 'ensnare_bnb'
require 'geocoder'
require_relative '../../lib/assets/geo/geocalc'

class Airbnb < Site

  SW = 0
  NE = 1

  def self.retrieve_sites area

    allRooms = {}

    area[SW] = Route::Calculation.coord_float_to_string(area[SW])
    area[NE] = Route::Calculation.coord_float_to_string(area[NE])
    EnsnareBnb.find_airbnb_hosts(sw: area[SW], ne: area[NE]).each do |room|
      if (!allRooms.has_key?(room[:id])) # Guarantee Unique
        # Check that it falls in the correct range . . .
        lat_upper_bound = area[NE][0].to_f
        lat_lower_bound = area[SW][0].to_f
        lng_upper_bound = area[NE][1].to_f
        lng_lower_bound = area[SW][1].to_f
        if (lat_upper_bound >= room[:latitude].to_f &&  lat_lower_bound <= room[:latitude].to_f &&
            lng_upper_bound >= room[:longitude].to_f && lng_lower_bound <= room[:longitude].to_f)
          allRooms[room[:id]] = room
        end
      end
    end

    gen_site(allRooms.values)
  end

  def self.get_max_pages area
    area[SW] = Route::Calculation.coord_float_to_string(area[SW])
    area[NE] = Route::Calculation.coord_float_to_string(area[NE])
    EnsnareBnb.get_max_pages_airbnb_hosts(sw: area[SW], ne: area[NE])
  end

  def self.gen_site rooms
    rooms.map do |room|  
    {
      name: room[:name],
      price: room[:price].to_f,
      latitude: room[:latitude].to_f,
      longitude: room[:longitude].to_f,
      url: room[:roomUrl],
      meta: {
        room_id: room[:id],
        user_id: room[:user_id],
        imgUrl: room[:imgUrl],
        location: room[:location]
      }
    }
    end
  end
end
