class SitesController < ApplicationController

  skip_before_filter  :verify_authenticity_token

  def index 
    result = RetrieveAllSites.run route_params

    if result[:success?]
      result[:sites].map do |site|
        site.as_json.select {|k,v| k != "created_at" && k != "updated_at"}
      end
      render json: result[:sites], status: 200
    else
      render json: result[:error], :status => :not_found
    end
  end

  def show
    @site = Site.find(params[:id])
    
    if(@site)
      @site = @site.as_json.select {|k,v| k != "created_at" && k != "updated_at"}
      render json: @site, status: 200
    else
      render :status => :not_found
    end
  end

  def route_params
    params.require(:route)
  end
end


