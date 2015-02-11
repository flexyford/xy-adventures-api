require_relative '../../lib/assets/geo/geocalc'
require 'geocoder'
class RetrieveSite

  SW = 0
  NE = 1
  LAT = 0
  LONG = 1

  DAYS = 7

  AIRBNB_MAX_PAGES = 56

  def self.run(params)
    sites = []

    # TODO - Extend to only Queries within the last week (UTC)
    areas = get_encompassing_routeAreas params[:area]

    updatedAreas = get_updated areas, DAYS

    # Destory all outdated RouteAreas
    outdatedAreas = get_outdated areas, DAYS

    outdatedAreas.each do |area|
      area.destroy
    end

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

      # Add Sites From External Sources
      sites.concat(get_airbnb_sites area) # Airbnb

      # Add area to Route Area Table
      RouteArea.create({
        :sw_latitude => area[SW][LAT].to_f,
        :sw_longitude => area[SW][LONG].to_f,
        :ne_latitude => area[NE][LAT].to_f,
        :ne_longitude => area[NE][LONG].to_f
      })
    end

    # Uniquify Most Recently Updated Rooms
    site_ids = {}
    sites.sort_by { |site| site.updated_at }
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

  def self.get_updated(tables, days)
    tables.select do |t|
      # Return All Areas that have been updated within the last week
      t[:updated_at] > DateTime.now - days
    end
  end

  def self.get_outdated(tables, days)
    tables.select do |t|
      # Return All Areas that have NOT been updated within the last week
      t[:updated_at] <= DateTime.now - days
    end
  end

  def self.get_encompassing_routeAreas(area)
    RouteArea.where(
      "sw_latitude <= ? AND sw_longitude <= ? AND " + 
      "ne_latitude >= ? AND ne_longitude >= ?", 
      area[SW][LAT].to_f,
      area[SW][LONG].to_f,
      area[NE][LAT].to_f,
      area[NE][LONG].to_f
    )
  end

  def self.get_airbnb_sites(routeArea)
    sites = []
    routeAreas = []

    pages = Airbnb.get_max_pages routeArea

    if(pages >= AIRBNB_MAX_PAGES)
      # Split into 4 equivalent sections
      routeAreas = Route::Calculation.divide_area(routeArea)
      routeAreas.each do |routeArea|
        sites.concat(get_airbnb_sites routeArea )
      end
    else
      airbnb_sites = Airbnb.retrieve_sites routeArea
      if airbnb_sites
        # Add all found Airbnbs to this routeArea
        airbnb_sites.each do |new_airbnb_site|
          old_airbnb_site = Site.where(
            "type = ? AND meta->>'room_id' = ?",
            "airbnb", new_airbnb_site[:meta][:room_id]
          ).first
          sites.push(build_model_entry new_airbnb_site, Airbnb, old_airbnb_site)
        end
      end
    end
    sites.uniq{ |site| site["meta"]["room_id"] }
  end

  def self.build_model_entry new_site, model, old_site = nil
    if(old_site)
      # Update Existing Model Entry
      if (old_site[:updated_at] <= DateTime.now - DAYS)
        # Update the Found Outdated Site
        old_site.update(new_site)
      end
    else
      # Create New Model Entry
      model.create(new_site)
    end
  end

end

# sites.length
# sites = Site.where(type: 'Airbnb').as_json
# sites.length
# sites.uniq{ |site| site.["meta"]["room_id"] }.length