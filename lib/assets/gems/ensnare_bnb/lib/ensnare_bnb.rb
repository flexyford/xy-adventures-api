
# EnsnareBnb.find_airbnb_hosts(city: 'Austin', state: 'TX', country: 'United-States', max_pages: 2)

require_relative 'ensnare_bnb/version'
require 'nokogiri'
require 'json'
require 'open-uri'
require 'active_support'
require 'active_support/core_ext/hash'
require 'pry-byebug'

module EnsnareBnb

  class << self

    MAX_PAGES = 56

    def max_page_number(url)
      pages = 1
      lines = open(url) {|f| f.readlines }
      idx = lines.index do |x| 
              x.include? "<div class=\"pagination pagination-responsive\">" 
            end
      if(idx)
        li_list = lines[idx].split( /(<li.*?\/li>)/ ).select{ |li| li.index('<li') == 0}
        if (li_list.length < 2)
          pages = li_list.length + 1
        else
          pages = li_list[li_list.length - 2].match(/>(\d+)</)[1].to_i
        end
      end
      pages
    end

    def get_max_pages_airbnb_hosts(**opts)

      city = opts.fetch(:city, nil)
      state = opts.fetch(:state, nil)
      country = opts.fetch(:country, nil)
      sw_coords = opts.fetch(:sw, nil)
      ne_coords = opts.fetch(:ne, nil)
      range = opts.fetch(:range, 10)
      sleep_time = opts.fetch(:sleep, 1)

      # build intelligent options hashes/params in URLparams
      base_url = "https://www.airbnb.com"

      city_query = ""
      coord_query = ""

      if( sw_coords && ne_coords )
        coord_query = "&sw_lat=" + sw_coords[0] + "&sw_lng=" + sw_coords[1] +
                      "&ne_lat=" + ne_coords[0] + "&ne_lng=" + ne_coords[1]
      elsif ( city )
        city_query = [city, state, country].compact.map do |str|
          str.gsub('-', '~').gsub(' ', '-')
        end.join('--')
      end

      search_params = opts.except(:city, :state, :country, :max_pages, :sw, :ne)
      query = city_query + "?" + search_params.to_query + coord_query

      search_url = "#{base_url}/s/#{query}"

      pages = self.max_page_number(search_url)

      if (pages > opts.fetch(:max_pages, MAX_PAGES))
        pages = opts.fetch(:max_pages, MAX_PAGES)
      end

      pages

    end

    def find_airbnb_hosts(**opts)

      # city, state, country
      # New-York--NY--United-States

      # To create new (and to remove old) logfile, add File::CREAT like:
      # file = File.open('logfile.log', File::WRONLY | File::APPEND | File::CREAT)
      # logger = Logger.new(file)

      # logger.info("Start")

      city = opts.fetch(:city, nil)
      state = opts.fetch(:state, nil)
      country = opts.fetch(:country, nil)
      sw_coords = opts.fetch(:sw, nil)
      ne_coords = opts.fetch(:ne, nil)
      range = opts.fetch(:range, 10)
      sleep_time = opts.fetch(:sleep, 1)

      # build intelligent options hashes/params in URLparams
      base_url = "https://www.airbnb.com"

      city_query = ""
      coord_query = ""

      if( sw_coords && ne_coords )
        coord_query = "&sw_lat=" + sw_coords[0] + "&sw_lng=" + sw_coords[1] +
                      "&ne_lat=" + ne_coords[0] + "&ne_lng=" + ne_coords[1]
      elsif ( city )
        city_query = [city, state, country].compact.map do |str|
          str.gsub('-', '~').gsub(' ', '-')
        end.join('--')
      end

      search_params = opts.except(:city, :state, :country, :max_pages, :sw, :ne)
      query = city_query + "?" + search_params.to_query + coord_query

      search_url = "#{base_url}/s/#{query}"
     
      pages = self.max_page_number(search_url)

      if (pages > opts.fetch(:max_pages, MAX_PAGES))
        pages = opts.fetch(:max_pages, MAX_PAGES)
      end

      @results = []

      th = []

      pages.times do |pg|

        th[pg] = Thread.new {

          # puts "Starting thread #{pg}"

          page_url = "#{search_url}?room_types%5B%5D=Entire+home%2Fapt&page=#{pg + 1}"

          Nokogiri::HTML(open(page_url)).css("div.col-sm-12.col-md-6.row-space-2").each do |room|

            listing = room.at_css('div.listing')
            img_listing = room.at_css(".listing-img-container > img")

            next if listing.nil?

            id       = listing['data-id']
            url      = base_url + listing['data-url']
            user_id  = listing['data-user']
            location = room.at_css('.listing-location > a')
            name     = listing['data-name']
            lat      = listing['data-lat']
            lng      = listing['data-lng']
            price    = room.at_css('.price-amount')
            img      = img_listing.nil? ? nil : img_listing['src']

            # If default image was not found, use alternate images
            if (img && img.match(/no_photos/))
              img_urls = img_listing['data-urls']
              if JSON.is_json?(img_urls)
                img = JSON.parse(img_urls).first
              else
                img = img_urls  
              end
            end

            output = {
              id: id,
              user_id: user_id,
              location: location.nil? ? nil : location.text.strip,
              name: name,
              price: price.nil? ? nil : price.text.to_f,
              latitude: lat,
              longitude: lng,
              roomUrl: url,
              imgUrl: img
            }

            @results << output
          end

          # puts "Finished thread #{pg}"
        }
        # prevent bombarding the server with too many requests at once (default=>1)
        # sleep(sleep_time)
      end
      th.each {|t| t.join; }
      # logger.info("Done")
      # logger.close()
      @results
    end

  end

end
