class RetrieveAllSites

  RANGE = 25

  def self.run(params)
    route = params

    th = []
    result = {
      :sites => []
    }

    routeAreas = RouteArea.build_route_areas(JSON.parse(route), RANGE)

    routeAreas.each_index do |idx|
      area = routeAreas[idx][:area]
      th[idx] = Thread.new {
        # Sites have not updated within last week
        retrieve = RetrieveSite.run routeAreas[idx]
        if retrieve[:success?]
          result[:sites].concat(retrieve[:sites])
        else
          result[:error] = retrieve
        end
      }
    end
    th.each {|t| t.join; }

    if !result[:error]
      # Uniquify By Room Id
      result[:sites].uniq!{|x| x[:id]}
      result[:success?] = true;
    end
    result
  end
end


