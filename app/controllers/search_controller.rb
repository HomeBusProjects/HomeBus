require 'pp'

class SearchController < ApplicationController
  def index
    pp search_params
    q = params[:q]

    @devices = Device.where("friendly_name ILIKE '%#{q}%' OR friendly_location ILIKE '%#{q}%'")
    @provision_requests = ProvisionRequest.where("friendly_name ILIKE '%#{q}%' OR friendly_location ILIKE '%#{q}'")
    @spaces = Space.where("friendly_name ILIKE '%#{q}%'")
  end

  private

  def search_params
    params.require(:q)
  end
end
