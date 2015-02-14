require 'geocoder'
require_relative '../../app/txs/retrieve_all_sites'
require_relative '../../app/txs/retrieve_site'
RANGE = 50

namespace :scraper do
  desc "Rake task to get Midwest Sites"
  task :midwest => :environment do
    # MidWest
    box = [["37.131131", "-101.691427"],["41.349327", "-81.037130"]]

    areas = RetrieveAllSites.split_route_area box, 2*RANGE

    areas.shuffle.each do |area|
      routeArea = {
        :area => area,
        :range => RANGE,
        :center => Geocoder::Calculations.geographic_center(area).map{ |point| point.to_s }
      }
      retrieve = RetrieveSite.run routeArea
      if !retrieve[:success?]
        puts "Scrape Failed for #{box}"
        puts "#{Time.now} - Failure!"
        break
      else
        puts "Scrape Successful for #{box}"
        puts "Example: #{retrieve[:sites].last.url}"
        puts "#{Time.now} - Success!"
      end
    end
  end

  desc "Rake task to get Pike National Forest Sites"
  task :pike => :environment do
    # NorthDakota
    box = [["38.786483519362044", "-105.89261390227028"],["39.37679051602722", "-105.02744056242653"]]
    range = 50

    areas = RetrieveAllSites.split_route_area box, 2*range

    puts "Searching #{areas.length} areas within #{box}"

    areas.shuffle.each do |area|
      routeArea = {
        :area => area,
        :range => RANGE,
        :center => Geocoder::Calculations.geographic_center(area).map{ |point| point.to_s }
      }
      retrieve = RetrieveSite.run routeArea
      if !retrieve[:success?]
        puts "Scrape Failed for #{box}"
        puts "#{Time.now} - Failure!"
        break
      else
        puts "Scrape Successful for #{box}"
        puts "Example: #{retrieve[:sites].last.url}"
        puts "#{Time.now} - Success!"
      end
    end
  end

  desc "Rake task to get NorthDakota"
  task :northdakota => :environment do
    # NorthDakota
    box = [["45.872402", "-103.999841"], ["48.934755", "-96.748865"]]
    range = 25

    areas = RetrieveAllSites.split_route_area box, 2*range

    puts "Searching #{areas.length} areas within #{box}"

    areas.shuffle.each do |area|
      routeArea = {
        :area => area,
        :range => RANGE,
        :center => Geocoder::Calculations.geographic_center(area).map{ |point| point.to_s }
      }
      retrieve = RetrieveSite.run routeArea
      if !retrieve[:success?]
        puts "Scrape Failed for #{box}"
        puts "#{Time.now} - Failure!"
        break
      else
        puts "Scrape Successful for #{box}"
        puts "Example: #{retrieve[:sites].last.url}"
        puts "#{Time.now} - Success!"
      end
    end
  end

  desc "Rake task to get Manhattan"
  task :manhattan => :environment do
    # Manhattan
    box = [["40.70960932582525","-74.02476801352736"], ["40.81577946626191","-73.9166213460469"]]
    range = 1.25

    areas = RetrieveAllSites.split_route_area box, 2*range

    puts "Searching #{areas.length} areas within #{box}"

    areas.shuffle.each do |area|
      routeArea = {
        :area => area,
        :range => RANGE,
        :center => Geocoder::Calculations.geographic_center(area).map{ |point| point.to_s }
      }
      retrieve = RetrieveSite.run routeArea
      if !retrieve[:success?]
        puts "Scrape Failed for #{box}"
        puts "#{Time.now} - Failure!"
        break
      else
        puts "Scrape Successful for #{box}"
        puts "Example: #{retrieve[:sites].last.url}"
        puts "#{Time.now} - Success!"
      end
    end
  end

  desc "Hello World Test"
  task :hello => :environment do
    # Pike National Forest
    puts "hello world"
  end
end