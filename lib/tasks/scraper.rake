require 'geocoder'
require 'pry-byebug'
require_relative '../../app/txs/retrieve_all_sites'
require_relative '../../app/txs/retrieve_site'
RANGE = 50

namespace :scraper do

  desc "Rake task to get Midwest Sites"
  task :midwest => :environment do
    # MidWest
    box = [["37.131131", "-101.691427"],["41.349327", "-81.037130"]]
    puts "#{Time.now} - Start!"

    update_params = {box: box}
    areas = RetrieveAllSites.update update_params

    puts "#{Time.now} - End!"
  end

  desc "Rake task to get South Carolina"
  task :southcarolina => :environment do
    # South Carolina
    box = [["31.912511769065443", "-82.39385887908526"],["35.67459552713459", "-78.93316551971026"]]
    puts "#{Time.now} - Start!"

    update_params = {box: box}
    areas = RetrieveAllSites.update update_params

    puts "#{Time.now} - End!"
  end

  desc "Rake task to get Pike National Forest Sites"
  task :pike => :environment do
    # Pike National Forest
    box = [["38.786483519362044", "-105.89261390227028"],["39.37679051602722", "-105.02744056242653"]]
    puts "#{Time.now} - Start!"

    update_params = {box: box}
    areas = RetrieveAllSites.update update_params

    puts "#{Time.now} - End!"
  end

  desc "Rake task to get NorthDakota"
  task :northdakota => :environment do
    # NorthDakota
    box = [["45.872402", "-103.999841"], ["48.934755", "-96.748865"]]
    puts "#{Time.now} - Start!"

    update_params = {box: box}
    areas = RetrieveAllSites.update update_params

    puts "#{Time.now} - End!"
  end

  desc "Rake task to get Manhattan"
  task :manhattan => :environment do
    # Manhattan
    box = [["40.70960932582525","-74.02476801352736"], ["40.81577946626191","-73.9166213460469"]]
    puts "#{Time.now} - Start!"

    update_params = {box: box}
    areas = RetrieveAllSites.update update_params

    puts "#{Time.now} - End!"
  end

  desc "Rake task to get Texas"
  task :texas => :environment do
    # Texas
    box = [["25.903552", "-106.333089"], ["36.319416", "-93.479084"]]
    puts "#{Time.now} - Start!"

    update_params = {box: box}
    areas = RetrieveAllSites.update update_params

    puts "#{Time.now} - End!"
  end

  desc "Rake task to get Continental US"
  task :continental => :environment do

    Geocoder::Configuration.timeout = 15
    
    # Continental US
    box = [["27.963019", "-123.124351"], ["48.841332", "-67.929038"]]
    puts "#{Time.now} - Start!"

    area = RetrieveAllSites.build_full_box box

    # Divide Area into 24 equal sections . . . 
    length = Geocoder::Calculations.distance_between( area[:sw], area[:se]);
    width = Geocoder::Calculations.distance_between( area[:sw], area[:nw]);
    side = [length, width].max
    boxes = RetrieveAllSites.split_route_area box, side / 24
    update_idx = Time.now.hour + 1
    update_boxes = []
    binding.pry
    boxes.each_index do |idx|
      if (idx + 1) % update_idx == 0
        update_boxes.push(boxes[idx])
      end
    end

    update_boxes.each do |box|
      update_params = {box: box}
      RetrieveAllSites.update update_params
    end

    puts "#{Time.now} - End!"
  end


  desc "Hello World Test"
  task :hello => :environment do
    # Pike National Forest
    puts "hello world"
  end
end