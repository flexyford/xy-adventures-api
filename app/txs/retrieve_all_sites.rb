class RetrieveAllSites

  RANGE = 20

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

    # South Carolina
    # box = [["31.912511769065443", "-82.39385887908526"],["35.67459552713459", "-78.93316551971026"]]

    # Wyoming - 20 √
    # box = [["41.005877", "-111.075240"], ["44.976264", "-104.037224"]]

    # North Dakota - 25 √
    # box = [["45.872402", "-103.999841"], ["48.934755", "-96.748865"]]

    # Texas - Exited Early
    # box = [["25.903552", "-106.333089"], ["36.319416", "-93.479084"]]

    # Denver -> LA - Exited Early
    # box = [["33.47369011830391", "-115.13950619355285"], ["40.65407376044618", "-108.21811947480285"]]

    # Pike National Forest - 50
    # box = [["38.786483519362044", "-105.89261390227028"],["39.37679051602722", "-105.02744056242653"]]

    # East Coast
    # box = [["35.841674556163134","-81.22930809783526"],["48.92340340451917","-67.38653466033526"]]

    # New York, NY
    # box = [["40.595368", "-75.017418"],["41.168498", "-73.567223"]]

    # Manhattan - 1.25 X / 0.5 √
    box = [["40.70960932582525","-74.02476801352736"], ["40.81577946626191","-73.9166213460469"]]

    # A few rentals on the east coast ~100
    # box = [["38.768707004353466", "-75.44835581259963"],["39.639776767898994", "-74.58318247275588"]]

    # West Coast
    #box = [["34.91971868081203","-124.84085771082653"],["48.19399460126978","-110.99808427332653"]]

    areas = split_route_area box, 2*RANGE

    areas.shuffle.each do |area|
      routeArea = {
        :area => box,
        :range => RANGE,
        :center => Geocoder::Calculations.geographic_center(area).map{ |point| point.to_s }
      }
      retrieve = RetrieveSite.run routeArea
      if retrieve[:success?]
        result[:sites].concat(retrieve[:sites])
      else
        result[:error] = retrieve
        break
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

    areas = split_route_area box, 2*RANGE

    puts "Searching #{areas.length} areas within #{box}"

    areas.shuffle.each do |area|
      routeArea = {
        :area => box,
        :range => RANGE,
        :center => Geocoder::Calculations.geographic_center(area).map{ |point| point.to_s }
      }
      # Empty variable to free RAM
      retrieve = {}
      retrieve = RetrieveSite.run routeArea
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

  private

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
      southern_boundary_boxes.push(build_box current_sw, side_length)
      if dist_to_bound < 1.5 * side_length
        southern_boundary_boxes.push(build_box current_sw, dist_to_bound)
        current_sw = boundary
      else
        current_sw = Geocoder::Calculations.endpoint(current_sw, 90, side_length).map{ |point| point.to_s }
      end
    end

    vertical_dist = Geocoder::Calculations.distance_between(area[:sw], area[:nw])

    # Build Squares to NorthWest Boundary
    southern_boundary_boxes.each do |x|

      current_sw = x[SW]
      boundary = Geocoder::Calculations.endpoint(current_sw, 0, vertical_dist).map{ |point| point.to_s }
      until current_sw == boundary do
        dist_to_bound = Geocoder::Calculations.distance_between(current_sw, boundary)
        results.push(build_box current_sw, side_length)
        if dist_to_bound < 1.5 * side_length
          results.push(build_box current_sw, dist_to_bound)
          current_sw = boundary
        else
          current_sw = Geocoder::Calculations.endpoint(current_sw, 90, side_length).map{ |point| point.to_s }
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

  def self.stack_box_up box, side_length
    sw = Geocoder::Calculations.endpoint(box[SW], 0, range).map{ |point| point.to_s }
    ne =  Geocoder::Calculations.endpoint(box[NE], 0, range).map{ |point| point.to_s }
    [sw, ne]
  end

end