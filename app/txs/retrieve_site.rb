
class RetrieveSite

  SW = 0
  NE = 1
  LAT = 0
  LONG = 1

  UPDATED_WITHIN_X_DAYS = 7

  def self.run(params)
    sites = []

    # TODO - Extend to only Queries within the last week (UTC)
    areas = get_encompassing_routeAreas params[:area]

    binding.pry
    updatedAreas = get_updated_areas areas

    if (updatedAreas.length > 0)
      # Get all Recently Queried Areas
      # Build all sites found within each area
      updatedAreas.each do |area|
        sites.concat(Site.where(
          "latitude >= ? AND longitude >= ? AND latitude <= ? AND longitude <= ?",
          area[:sw_latitude], area[:sw_longitude], area[:ne_latitude], area[:ne_longitude]
        ))
      end 
    else
      # Querying New Area; Create/Update Sites and create RouteArea
      point = Route::Calculation.coord_float_to_string(params[:center])
      area = Route::Calculation.get_SW_NE_coordinates(point, 2 * params[:range])

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
            # TODO - Update only if it's > 1 Week Old
            found = found.update(airbnb_params)
            sites.push(found)
          else
            # Create New Airbnb Entry
            airbnb = Airbnb.create(airbnb_params)
            sites.push(airbnb)
          end
        end
        if (areas.length > 0)

        end
        # Add area to Route Area Table
        RouteArea.create({
          :sw_latitude => area[SW][LAT].to_f,
          :sw_longitude => area[SW][LONG].to_f,
          :ne_latitude => area[NE][LAT].to_f,
          :ne_longitude => area[NE][LONG].to_f
        })
      end
    end

    # Destory all outdated RouteAreas
    outdatedAreas = get_outdated_areas areas

    binding.pry

    outdatedAreas.each do |area|
      area.destroy
    end

    # Uniquify Most Recently Updated Rooms
    site_ids = {}
    binding.pry
    sites.sort_by! { |site| site.updated_at }
      .keep_if do |site|
        if(!site_ids[site.id])
        site_ids[site.id] = true
        end
      end

    if sites
      {:status => 200, :success? => true, :sites => sites}
    else
      {:status => :not_found, :error => 'airbnb_scrape_failed', :area => JSON.stringify(params) }
    end
  end

  private

  def self.get_updated_areas(areas)
    areas.select do |area|
      # Return All Areas that have been updated within the last week
      area[:updated_at] > DateTime.now - UPDATED_WITHIN_X_DAYS
    end
  end

  def self.get_outdated_areas(areas)
    areas.select do |area|
      # Return All Areas that have NOT been updated within the last week
      area[:updated_at] <= DateTime.now - UPDATED_WITHIN_X_DAYS
    end
  end

  def self.get_encompassing_routeAreas area
    RouteArea.where(
      "sw_latitude <= ? AND sw_longitude <= ? AND " + 
      "ne_latitude >= ? AND ne_longitude >= ?", 
      area[SW][LAT].to_f,
      area[SW][LONG].to_f,
      area[NE][LAT].to_f,
      area[NE][LONG].to_f
    )
  end

end