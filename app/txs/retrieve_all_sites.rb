require 'pry-byebug'
class RetrieveAllSites

  UPDATE_RANGE = 50
  RANGE = 2.5

  SW = 0
  NE = 1
  LAT = 0
  LONG = 1

  def self.run(params)
    route = params

    th = []
    result = {
      :sites => []
    }
    routeAreas = RouteArea.build_route_areas(JSON.parse(route), RANGE)

    routeAreas.each_index do |idx|
      area = routeAreas[idx][:area]
      # Sites have not updated within last week
      retrieve = RetrieveSite.run routeAreas[idx]
      if retrieve[:success?]
        result[:sites].concat(retrieve[:sites])
      else
        result[:error] = retrieve
      end
    end

    if !result[:error]
      # Uniquify By Room Id
      result[:sites].uniq!{|x| x[:id]}
      result[:success?] = true;
    end
    result
  end

  def self.update(params)
    box = params[:box]

    th = []
    result = {
      :sites => []
    }

    # Manhattan - 1.25 X / 0.5 √
    # box = [["40.70960932582525","-74.02476801352736"], ["40.81577946626191","-73.9166213460469"]]

    areas = split_route_area box, 2*UPDATE_RANGE

    puts "Searching #{areas.length} areas within #{box}"

    areas.shuffle.each do |area|
      routeArea = {
        :area => area,
        :range => UPDATE_RANGE,
        :center => Geocoder::Calculations.geographic_center(area).map{ |point| point.to_s }
      }
      # Empty variable to free RAM
      retrieve = {}
      retrieve = RetrieveSite.update routeArea
      if !retrieve[:success?]
        puts "Scrape Failed for #{area} within #{box}"
        puts "#{Time.now} - Failure!"
        result[:error] = retrieve
        break
      else
        puts "Scrape Successful for #{area}: Returned #{retrieve[:sites].length} results"
        if retrieve[:sites].length > 0
          puts "Example: #{retrieve[:sites].last.url}"
        end
        puts "#{Time.now} - Success!"
      end
    end

    if !result[:error]
      # Uniquify By Room Id
      result[:success?] = true;
    end
    result
  end

  def self.build_full_box box
    # Build Square out of box
    center  = Geocoder::Calculations.geographic_center(box).map{ |point| point.to_s }
    hyp     = Geocoder::Calculations.distance_between( center, box[NE])

    heading_center_sw = Geocoder::Calculations.bearing_between( center,box[SW] )
    heading_center_ne = Geocoder::Calculations.bearing_between( center,box[NE] )

    heading_center_nw = 360 - heading_center_ne
    heading_center_se = 360 - heading_center_sw
    
    n_west = Geocoder::Calculations.endpoint(center, heading_center_nw, hyp).map{ |point| point.to_s }
    s_east = Geocoder::Calculations.endpoint(center, heading_center_se, hyp).map{ |point| point.to_s }
    {
      :sw => box[SW],
      :ne => box[NE],
      :nw => n_west,
      :se => s_east,
      :center => center
    }
  end


  def self.split_route_area box, side_length
    results = []

    area = build_full_box box

    # Build Squares to SouthEast Boundary
    southern_boundary_boxes = []
    current_sw = area[:sw]
    boundary = area[:se]

    until current_sw == boundary do
      dist_to_bound = Geocoder::Calculations.distance_between(current_sw, boundary)
      if dist_to_bound < side_length
        southern_boundary_boxes.push(build_box current_sw, dist_to_bound)
        current_sw = boundary
      else
        southern_boundary_boxes.push(build_box current_sw, side_length)
        current_sw = Geocoder::Calculations.endpoint(current_sw, 90, side_length).map{ |point| point.to_s }
      end
    end

    vertical_dist = Geocoder::Calculations.distance_between(area[:sw], area[:nw])

    # Build Squares to NorthWest Boundary
    southern_boundary_boxes.each do |x|

      current_sw = x[SW]
      current_ne = x[NE]
      boundary = Geocoder::Calculations.endpoint(current_sw, 0, vertical_dist).map{ |point| point.to_s }
      until current_sw == boundary do
        dist_to_bound = Geocoder::Calculations.distance_between(current_sw, boundary)
        if dist_to_bound < side_length
          results.push([current_sw, current_ne])
          current_sw = boundary
        else
          results.push([current_sw, current_ne])
          current_sw = Geocoder::Calculations.endpoint(current_sw, 0, side_length).map{ |point| point.to_s }
          current_ne = Geocoder::Calculations.endpoint(current_ne, 0, side_length).map{ |point| point.to_s }
        end
      end
    end

    results

  end

  def self.build_box sw_coord, side_length
    se_coord = Geocoder::Calculations.endpoint(sw_coord, 90, side_length)
    ne_coord = Geocoder::Calculations.endpoint(se_coord,  0, side_length).map{ |point| point.to_s }
    box  = [sw_coord, ne_coord]
  end

end