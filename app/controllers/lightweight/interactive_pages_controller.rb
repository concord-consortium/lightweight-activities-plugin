require_dependency "lightweight/application_controller"

module Lightweight
  class InteractivePagesController < ApplicationController
    before_filter :set_page, :except => [:new, :create]

    def show
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

    def new
      # There's really nothing to do here; we can go through #create and skip on ahead to #edit.
      create
    end

    def create
      @activity = Lightweight::LightweightActivity.find(params[:activity_id])
      @page = Lightweight::InteractivePage.create!(:lightweight_activity => @activity)
      redirect_to edit_activity_page_path(@activity, @page)
    end

    def edit
    end

    def update
      if @page.update_attributes(params[:interactive_page])
        redirect_to edit_activity_page_path(@activity, @page)
      else
        redirect_to edit_activity_page_path(@activity, @page)
      end
    end

    private
    def set_page
      if params[:activity_id]
        @activity = Lightweight::LightweightActivity.find(params[:activity_id], :include => :pages)
        @page = @activity.pages.find(params[:id])
        # TODO: Exception handling if the ID'd Page doesn't belong to the ID'd Activity
      else
        # I don't like this method much.
        @page = Lightweight::InteractivePage.find(params[:id], :include => :lightweight_activity)
        @activity = @page.lightweight_activity
      end
    end

    # This is borrowed from the Portal::Offerings controller and should perhaps be more generalized.
    def setup_portal_student
      learner = nil
      if current_user
        portal_student = current_user.portal_student
        # create a learner for the user if one doesn't exist
        learner = @offering.find_or_create_learner(portal_student)
      end
      learner
    end
  end
end
