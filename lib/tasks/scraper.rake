require 'geocoder'
require_relative '../../app/txs/retrieve_all_sites'
require_relative '../../app/txs/retrieve_site'
RANGE = 50

namespace :scraper do

  desc "Rake task to get Midwest Sites"
  task :midwest => :environment do
    # MidWest
    box = [["37.131131", "-101.691427"],["41.349327", "-81.037130"]]
    puts "#{Time.now} - Start!"

    areas = RetrieveAllSites.split_route_area box, 2*RANGE

    areas.shuffle.each do |area|
      routeArea = {
        :area => area,
        :range => RANGE,
        :center => Geocoder::Calculations.geographic_center(area).map{ |point| point.to_s }
      }
      retrieve = RetrieveSite.run routeArea
      if !retrieve[:success?]
        puts "Scrape Failed for #{area} within #{box}"
        puts "#{Time.now} - Failure!"
        break
      else
        puts "Scrape Successful for #{area}: Returned #{retrieve[:sites].length} results"
        if retrieve[:sites].length > 0
          puts "Example: #{retrieve[:sites].last.url}"
        end
        puts "#{Time.now} - Success!"
      end
    end
    puts "#{Time.now} - End!"
  end

  desc "Rake task to get South Carolina"
  task :southcarolina => :environment do
    # South Carolina
    box = [["31.912511769065443", "-82.39385887908526"],["35.67459552713459", "-78.93316551971026"]]
    range = 25
    puts "#{Time.now} - Start!"

    areas = RetrieveAllSites.split_route_area box, 2*range

    puts "Searching #{areas.length} areas within #{box}"

    areas.shuffle.each do |area|
      routeArea = {
        :area => area,
        :range => range,
        :center => Geocoder::Calculations.geographic_center(area).map{ |point| point.to_s }
      }
      retrieve = RetrieveSite.run routeArea
      if !retrieve[:success?]
        puts "Scrape Failed for #{area} within #{box}"
        puts "#{Time.now} - Failure!"
        break
      else
        puts "Scrape Successful for #{area}: Returned #{retrieve[:sites].length} results"
        if retrieve[:sites].length > 0
          puts "Example: #{retrieve[:sites].last.url}"
        end
        puts "#{Time.now} - Success!"
      end
    end
    puts "#{Time.now} - End!"
  end

  desc "Rake task to get Pike National Forest Sites"
  task :pike => :environment do
    # NorthDakota
    box = [["38.786483519362044", "-105.89261390227028"],["39.37679051602722", "-105.02744056242653"]]
    range = 50
    puts "#{Time.now} - Start!"

    areas = RetrieveAllSites.split_route_area box, 2*range

    puts "Searching #{areas.length} areas within #{box}"

    areas.shuffle.each do |area|
      routeArea = {
        :area => area,
        :range => range,
        :center => Geocoder::Calculations.geographic_center(area).map{ |point| point.to_s }
      }
      retrieve = RetrieveSite.run routeArea
      if !retrieve[:success?]
        puts "Scrape Failed for #{area} within #{box}"
        puts "#{Time.now} - Failure!"
        break
      else
        puts "Scrape Successful for #{area}: Returned #{retrieve[:sites].length} results"
        if retrieve[:sites].length > 0
          puts "Example: #{retrieve[:sites].last.url}"
        end
        puts "#{Time.now} - Success!"
      end
    end
    puts "#{Time.now} - End!"
  end

  desc "Rake task to get NorthDakota"
  task :northdakota => :environment do
    # NorthDakota
    box = [["45.872402", "-103.999841"], ["48.934755", "-96.748865"]]
    range = 25
    puts "#{Time.now} - Start!"

    areas = RetrieveAllSites.split_route_area box, 2*range

    puts "Searching #{areas.length} areas within #{box}"

    areas.shuffle.each do |area|
      routeArea = {
        :area => area,
        :range => range,
        :center => Geocoder::Calculations.geographic_center(area).map{ |point| point.to_s }
      }
      retrieve = RetrieveSite.run routeArea
      if !retrieve[:success?]
        puts "Scrape Failed for #{area} within #{box}"
        puts "#{Time.now} - Failure!"
        break
      else
        puts "Scrape Successful for #{area}: Returned #{retrieve[:sites].length} results"
        if retrieve[:sites].length > 0
          puts "Example: #{retrieve[:sites].last.url}"
        end
        puts "#{Time.now} - Success!"
      end
    end
    puts "#{Time.now} - End!"
  end

  desc "Rake task to get Manhattan"
  task :manhattan => :environment do
    # Manhattan
    box = [["40.70960932582525","-74.02476801352736"], ["40.81577946626191","-73.9166213460469"]]
    range = 1.25
    puts "#{Time.now} - Start!"

    areas = RetrieveAllSites.split_route_area box, 2*range

    puts "Searching #{areas.length} areas within #{box}"

    areas.shuffle.each do |area|
      routeArea = {
        :area => area,
        :range => range,
        :center => Geocoder::Calculations.geographic_center(area).map{ |point| point.to_s }
      }
      retrieve = RetrieveSite.run routeArea
      if !retrieve[:success?]
        puts "Scrape Failed for #{area} within #{box}"
        puts "#{Time.now} - Failure!"
        break
      else
        puts "Scrape Successful for #{area}: Returned #{retrieve[:sites].length} results"
        if retrieve[:sites].length > 0
          puts "Example: #{retrieve[:sites].last.url}"
        end
        puts "#{Time.now} - Success!"
      end
    end
    puts "#{Time.now} - End!"
  end

  desc "Rake task to get Texas"
  task :texas => :environment do
    # Texas
    box = [["25.903552", "-106.333089"], ["36.319416", "-93.479084"]]
    range = 50
    puts "#{Time.now} - Start!"

    areas = RetrieveAllSites.split_route_area box, 2*range

    puts "Searching #{areas.length} areas within #{box}"

    areas.shuffle.each do |area|
      routeArea = {
        :area => area,
        :range => range,
        :center => Geocoder::Calculations.geographic_center(area).map{ |point| point.to_s }
      }
      retrieve = RetrieveSite.run routeArea
      if !retrieve[:success?]
        puts "Scrape Failed for #{area} within #{box}"
        puts "#{Time.now} - Failure!"
        break
      else
        puts "Scrape Successful for #{area}: Returned #{retrieve[:sites].length} results"
        if retrieve[:sites].length > 0
          puts "Example: #{retrieve[:sites].last.url}"
        end
        puts "#{Time.now} - Success!"
      end
    end
    puts "#{Time.now} - End!"
  end


  desc "Hello World Test"
  task :hello => :environment do
    # Pike National Forest
    puts "hello world"
  end
end