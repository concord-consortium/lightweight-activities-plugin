require_dependency "lightweight/application_controller"

module Lightweight
  class InteractivePageController < ApplicationController
    def show
      @page = Lightweight::InteractivePage.find(params[:id])
      @activity = @page.lightweight_activity
      # TODO: Select the offering properly rather than hard-wiring it.
      if (params[:offering_id])
        begin
          @offering = @activity.offerings.find(params[:offering_id])
        rescue
          # HACK: This is a bad data situation, where the page comes from a
          # different activity than the runnable for the offering.
          # The correct response should be some kind of error page, I think.
          @offering = @activity.offerings.first
        end
      else
        @offering = @activity.offerings.first
      end
      all_pages = @activity.pages
      current_idx = all_pages.index(@page)
      @previous_page = (current_idx > 0) ? all_pages[current_idx-1] : nil
      @next_page = (current_idx < (all_pages.size-1)) ? all_pages[current_idx+1] : nil
    end
  end
end
