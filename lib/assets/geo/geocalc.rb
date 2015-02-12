require 'geocoder'
require 'pry-byebug'

module Route
  module Calculation
    extend self

    ##
    # Distance between two points on Earth (Haversine formula).
    # Takes two points and an options hash.
    # The points are given in the same way that points are given to all
    # Geocoder methods that accept points as arguments. They can be:
    #
    # * an array of coordinates ([lat,lon])
    # * a geocodable address (string)
    # * a geocoded object (one which implements a +to_coordinates+ method
    #   which returns a [lat,lon] array
    #
    # The options hash supports:
    #
    # * <tt>:units</tt> - <tt>:mi</tt> or <tt>:km</tt>
    #   Use Geocoder.configure(:units => ...) to configure default units.
    #
    def distance_between(point1, point2, options = {})
      Geocoder::Calculations.distance_between(point1, point2, options)
    end

    # Given a box[0] = sw coord and box[1] = ne coord Box
    # returns 4 equivalent boxes such that
    # boxes[0] - NE Quadrant
    # boxes[1] - NW Quadrant
    # boxes[2] - SW Quadrant
    # boxes[3] - SE Quadrant
    def divide_area(box)
      boxes = []

      distance = ((distance_between box[0], box[1]) / Math.sqrt(2)) / 2
      center = coord_float_to_string Geocoder::Calculations.geographic_center(box)
      north  = coord_float_to_string Geocoder::Calculations.endpoint(center, 0, distance)
      south  = coord_float_to_string Geocoder::Calculations.endpoint(center, 180, distance)
      east   = coord_float_to_string Geocoder::Calculations.endpoint(center, 90, distance)
      west   = coord_float_to_string Geocoder::Calculations.endpoint(center, 270, distance)
      boxes.push( [center, box[1]] ) # NE Quadrant
      boxes.push( [west,   north]  ) # NW Quadrant
      boxes.push( [box[0], center] ) # SW Quadrant
      boxes.push( [south,  east]   ) # SE Quadrant

      return boxes
    end

    def coord_float_to_string(coord) 
      coord.map { |point| point.to_s }
    end

    def get_SW_NE_coordinates(coord, range)

      box = []

      bounding_box = Geocoder::Calculations.bounding_box(coord, range)
      # box will be in form: [["26.0196", "-80.2871"], ["26.1063", "-80.1906"]]
      box.push(coord_float_to_string([bounding_box[0], bounding_box[1]]))
      box.push(coord_float_to_string([bounding_box[2], bounding_box[3]]))
    end

  end
end
