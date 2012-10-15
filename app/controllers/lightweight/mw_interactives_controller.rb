require_dependency "lightweight/application_controller"

module Lightweight
  class MwInteractivesController < ApplicationController
    def new
      create
    end

    def create
      if (params[:page_id])
        @page = Lightweight::InteractivePage.find(params[:page_id])
        @interactive = Lightweight::MwInteractive.create!()
        Lightweight::InteractiveItem.create!(:interactive_page => @page, :interactive => @interactive)
        flash[:notice] = "Your new MW Interactive has been created."
        redirect_to edit_page_mw_interactive_path(@page, @interactive)
      else
        @interactive = Lightweight::MwInteractive.create!()
        flash[:notice] = "Your new MW Interactive has been created."
        redirect_to edit_mw_interactive_path(@interactive)
      end
    end

    def edit
    end

    def update
    end
  end
end
