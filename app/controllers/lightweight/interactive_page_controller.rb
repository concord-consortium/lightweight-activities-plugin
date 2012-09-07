require_dependency "lightweight/application_controller"

module Lightweight
  class InteractivePageController < ApplicationController
    def show
      theme :set_theme
      @page = Lightweight::InteractivePage.find(params[:id])
      @activity = @page.lightweight_activity
      all_pages = @activity.pages
      current_idx = all_pages.index(@page)
      @previous_page = (current_idx > 0) ? all_pages[current_idx-1] : nil
      @next_page = (current_idx < (all_pages.size-1)) ? all_pages[current_idx+1] : nil
    end

    private
    def set_theme(page)
      return "default"
    end
  end
end
