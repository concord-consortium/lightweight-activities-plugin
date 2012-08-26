require_dependency "lightweight/application_controller"

module Lightweight
  class LightweightActivityController < ApplicationController
    def show
      @activity = Lightweight::LightweightActivity.find(params[:id])
    end
  end
end
