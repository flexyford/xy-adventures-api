
class RetrieveSite

  SW = 0
  NE = 1
  LAT = 0
  LONG = 1

  def self.run(params)
    area = params[:area]
    range = params[:range]
    # Check if Area Already Exists In db

    areas = RouteArea.where(
      "sw_latitude <= ? AND sw_longitude <= ? AND " + 
      "ne_latitude >= ? AND ne_longitude >= ?", 
      area[SW][LAT],
      area[SW][LONG],
      area[NE][LAT],
      area[NE][LONG]
    )

    sites = []

    # No area found that contains this solution
    if(areas.length == 0)

      # Double Range
      point = Route::Calculation.coord_float_to_string(params[:center])
      area = Route::Calculation.get_SW_NE_coordinates(point, range * 2)

      # Handle New Airbnb Sites
      airbnbs = Airbnb.retrieve_sites area
      if airbnbs
        # Add all found Airbnbs to this area
        airbnbs.each do |airbnb_params|
          # Create new airbnbs
          found = Site.where(
            "type = ? AND meta->>'room_id' = ?",
            "airbnb",
            airbnb_params[:meta][:room_id]
          ).first

          if(found)
            # Update Existing Airbnb Entry
            found = found.update(airbnb_params)
            sites.push(found)
          else
            # Create New Airbnb Entry
            airbnb = Airbnb.create(airbnb_params)
            sites.push(airbnb)
          end
        end
        # Add area to Route Area Table
        RouteArea.create({
          :sw_latitude => area[SW][LAT],
          :sw_longitude => area[SW][LONG],
          :ne_latitude => area[NE][LAT],
          :ne_longitude => area[NE][LONG]
        })
      end
    else
      # Return all sites found within all areas
      areas.each do |area|
        sites.concat(Site.where(
          "latitude >= ? AND latitude <= ? AND longitude >= ? AND longitude <= ?",
          area[SW][LAT], area[NE][LAT], area[SW][LONG], area[NE][LONG]
        ))
      end
    end

    # Uniquify By Room Id
    sites.uniq!{|x| x[:id]}

    if sites
      {:status => 200, :success? => true, :sites => sites}
    else
      {:status => :not_found, :error => 'airbnb_scrape_failed', :area => JSON.stringify(params) }
    end
  end

  def site_params
    params.permit
  end

end