class SitesController < ApplicationController

  skip_before_filter  :verify_authenticity_token

  def index
    @sites = Site.retrieve_all_sites route_params
    binding.pry
    render json: @sites, status: 200
  end

  def show
    @site = Site.find(params[:id])
    render json: @site, status: 200
  end

  def route_params
    params.require(:route)
  end
end


