require_dependency "lightweight/application_controller"

module Lightweight
  class LightweightActivitiesController < ApplicationController
    def index
      @activities = Lightweight::LightweightActivity.find_all_by_user_id(current_user.id) unless current_user.blank?
      @activities ||= Lightweight::LightweightActivity.find(:all)
    end

    def show
      @activity = Lightweight::LightweightActivity.find(params[:id])
      # If we're given an offering ID, use that to set the offering; otherwise just take the first one.
      @offering = params[:offering_id] ? Portal::Offering.find(params[:offering_id]) : @activity.offerings.first
      redirect_to activity_page_path(@activity, @activity.pages.first, @offering)
    end

    def new
      @activity = Lightweight::LightweightActivity.new()
    end

    def create
      @activity = Lightweight::LightweightActivity.create(params[:lightweight_activity])
      if @activity.save
        redirect_to edit_activity_path(@activity)
      else
        # TODO: Flash error message
        render :new
      end
    end

    def edit
      @activity = Lightweight::LightweightActivity.find(params[:id])
    end

    def update
      @activity = Lightweight::LightweightActivity.find(params[:id])
      if @activity.update_attributes(params[:lightweight_activity])
        redirect_to activity_path(@activity)
      else
        # TODO: Flash error message
        redirect_to edit_activity_path(@activity)
      end
    end
  end
end
