require_dependency "lightweight/application_controller"

module Lightweight
  class InteractivePageController < ApplicationController
    def show
      @page = Lightweight::InteractivePage.find(params[:id])
      @activity = @page.lightweight_activity
      # TODO: Select the offering properly rather than hard-wiring it.
      @offering = @activity.offerings.first
      all_pages = @activity.pages
      current_idx = all_pages.index(@page)
      @previous_page = (current_idx > 0) ? all_pages[current_idx-1] : nil
      @next_page = (current_idx < (all_pages.size-1)) ? all_pages[current_idx+1] : nil
    end
  end
end
