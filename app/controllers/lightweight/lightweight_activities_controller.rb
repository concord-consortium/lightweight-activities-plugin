require_dependency "lightweight/application_controller"

module Lightweight
  class LightweightActivitiesController < ApplicationController
    def show
      @activity = Lightweight::LightweightActivity.find(params[:id])
      # If we're given an offering ID, use that to set the offering; otherwise just take the first one.
      @offering = params[:offering_id] ? Portal::Offering.find(params[:offering_id]) : @activity.offerings.first
      redirect_to interactive_page_show_url(@activity.pages.first, @offering)
    end
  end
end
