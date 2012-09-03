require_dependency "lightweight/application_controller"

module Lightweight
  class LightweightActivityController < ApplicationController
    def show
      @activity = Lightweight::LightweightActivity.find(params[:id])
      redirect_to interactive_page_show_url(@activity.pages.first)
    end
  end
end
