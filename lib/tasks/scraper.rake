require 'geocoder'
require_relative '../../app/txs/retrieve_all_sites'
require_relative '../../app/txs/retrieve_site'
RANGE = 50

namespace :scraper do
  desc "Rake task to get Pike National Forest Sites"
  task :midwest => :environment do
    # MidWest
    box = [["37.131131", "-101.691427"],["41.349327", "-81.037130"]]

    areas = RetrieveAllSites.split_route_area box, 2*RANGE

    areas.shuffle.each do |area|
      routeArea = {
        :area => box,
        :range => RANGE,
        :center => Geocoder::Calculations.geographic_center(area).map{ |point| point.to_s }
      }
      retrieve = RetrieveSite.run routeArea
      if !retrieve[:success?]
        puts "Scrape Successful for #{box}"
      else
        puts "Scrape Failed for #{box}"
        break
      end
    end
    puts "#{Time.now} - Success!"
  end

  desc "Rake task to get Pike National Forest Sites"
  task :pike => :environment do
    # East
    box = [["35.841674556163134","-81.22930809783526"],["48.92340340451917","-67.38653466033526"]]

    areas = RetrieveAllSites.split_route_area box, 2*RANGE

    puts "#{areas.length}"

    # areas.shuffle.each do |area|
    #   routeArea = {
    #     :area => box,
    #     :range => RANGE,
    #     :center => Geocoder::Calculations.geographic_center(area).map{ |point| point.to_s }
    #   }
    #   retrieve = RetrieveSite.run routeArea
    #   if !retrieve[:success?]
    #     puts "Scrape Successful for #{box}"
    #   else
    #     puts "Scrape Failed for #{box}"
    #     break
    #   end
    # end
    puts "#{Time.now} - Success!"
  end

  desc "Hello World Test"
  task :hello => :environment do
    # Pike National Forest
    puts "hello world"
  end
end
