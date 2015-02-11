
class RetrieveSite

  SW = 0
  NE = 1
  LAT = 0
  LONG = 1

  def self.run(params)
    area = params[:area]
    range = params[:range]

    # TODO - Extend to only Queries within the last week (UTC)
    areas = RouteArea.where(
      "sw_latitude <= ? AND sw_longitude <= ? AND " + 
      "ne_latitude >= ? AND ne_longitude >= ?", 
      area[SW][LAT].to_f,
      area[SW][LONG].to_f,
      area[NE][LAT].to_f,
      area[NE][LONG].to_f
    )

    sites = []

    
    if(areas.length == 0)
      # Querying New Area; Create/Update Sites and create RouteArea

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
          :sw_latitude => area[SW][LAT].to_f,
          :sw_longitude => area[SW][LONG].to_f,
          :ne_latitude => area[NE][LAT].to_f,
          :ne_longitude => area[NE][LONG].to_f
        })
      end
    else
      # Querying Recently Queried Areas
      # Build all sites found within each area

      areas.each do |area|
        sites.concat(Site.where(
          "latitude >= ? AND longitude >= ? AND latitude <= ? AND longitude <= ?",
          area[:sw_latitude], area[:sw_longitude], area[:ne_latitude], area[:ne_longitude]
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