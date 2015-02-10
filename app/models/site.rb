class Site < ActiveRecord::Base
  def self.retrieve_all_sites route

    sites = []

    # Retrieve Airbnb Sites
    airbnbSites = Airbnb.retrieve_all_sites route

    binding.pry

    sites.concat(airbnbSites)

    sites

  end

end
