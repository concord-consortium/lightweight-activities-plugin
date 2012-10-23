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
      @interactive = Lightweight::MwInteractive.find(params[:id])
      if params[:page_id]
        @page = Lightweight::InteractivePage.find(params[:page_id])
      end
    end

    def update
      @interactive = Lightweight::MwInteractive.find(params[:id])
      if params[:page_id]
        @page = Lightweight::InteractivePage.find(params[:page_id])
      end
      if (@interactive.update_attributes(params[:mw_interactive]))
        # respond success
        flash[:notice] = 'Your MW Interactive was updated'
      else
        flash[:warning] = "There was a problem updating your MW Interactive"
      end
      respond_to do |format|
        if @page
          format.html { redirect_to edit_page_mw_interactive_path(@page, @interactive) }
          format.json { respond_with_bip @interactive }
        else
          format.html { redirect_to edit_mw_interactive_path(@interactive) }
          format.json { respond_with_bip @interactive }
        end
      end
    end
  end
end
