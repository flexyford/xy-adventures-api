class RetrieveAllSites

  RANGE = 25

  def self.run(params)
    route = params

    th = []
    result = {
      :sites => []
    }

    # Wyoming
    box = [["41.005877", "-111.075240"], ["44.976264", "-104.037224"]]

    # Denver -> LA
    # box = [["33.47369011830391", "-115.13950619355285"], ["40.65407376044618", "-108.21811947480285"]]

    # Pike National Forest
    # box = [["38.786483519362044", "-105.89261390227028"],["39.37679051602722", "-105.02744056242653"]]

    range = ( (Geocoder::Calculations.distance_between( box[0],box[1] ) / Math.sqrt(2) ) / 2)
    center = Geocoder::Calculations.geographic_center(box).map{ |point| point.to_s }
    north  = Geocoder::Calculations.endpoint(center, 0, range).map{ |point| point.to_s }
    south  = Geocoder::Calculations.endpoint(center, 180, range).map{ |point| point.to_s }
    east   = Geocoder::Calculations.endpoint(center, 90, range).map{ |point| point.to_s }
    west   = Geocoder::Calculations.endpoint(center, 270, range).map{ |point| point.to_s }
    s_west = Geocoder::Calculations.endpoint(south, 270, range).map{ |point| point.to_s }
    n_east = Geocoder::Calculations.endpoint(north, 90, range).map{ |point| point.to_s }

    square = [s_west, n_east]

    routeArea = {
        :area => square,
        :range => range,
        :center => center
      }

    retrieve = RetrieveSite.run routeArea

    if retrieve[:success?]
      result[:sites].concat(retrieve[:sites])
    else
      result[:error] = retrieve
    end

    if !result[:error]
      # Uniquify By Room Id
      result[:sites].uniq!{|x| x[:id]}
      result[:success?] = true;
    end
    result
  end
end


