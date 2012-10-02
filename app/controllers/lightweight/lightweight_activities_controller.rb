require_dependency "lightweight/application_controller"

module Lightweight
  class LightweightActivitiesController < ApplicationController
    def index
      @activities = Lightweight::LightweightActivity.find(:all, :user_id => current_user.id) unless current_user.blank?
      @activities ||= Lightweight::LightweightActivity.find(:all)
    end

    def show
      @activity = Lightweight::LightweightActivity.find(params[:id])
      # If we're given an offering ID, use that to set the offering; otherwise just take the first one.
      @offering = params[:offering_id] ? Portal::Offering.find(params[:offering_id]) : @activity.offerings.first
      redirect_to activity_page_path(@activity, @activity.pages.first, @offering)
    end
  end
end
