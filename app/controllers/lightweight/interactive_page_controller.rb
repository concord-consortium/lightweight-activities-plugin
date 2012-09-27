require_dependency "lightweight/application_controller"

include AuthorizedSystem unless !defined? AuthorizedSystem

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
      if @offering
        @learner = setup_portal_student
      end
      @all_pages = @activity.pages
      current_idx = @all_pages.index(@page)
      @previous_page = (current_idx > 0) ? @all_pages[current_idx-1] : nil
      @next_page = (current_idx < (@all_pages.size-1)) ? @all_pages[current_idx+1] : nil

      respond_to do |format|
        format.html
        format.xml
        format.run_html { render :show }
      end
    end

    private
    # This is borrowed from the Portal::Offerings controller and should perhaps be more generalized.
    def setup_portal_student
      learner = nil
      # TODO: Ignore this if lib/authorized_system is not present
      if portal_student = current_user.portal_student
        # create a learner for the user if one doesnt' exist
        learner = @offering.find_or_create_learner(portal_student)
      end
      learner
    end
  end
end
