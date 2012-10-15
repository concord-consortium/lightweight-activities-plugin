require 'spec_helper'

describe Lightweight::MwInteractivesController do
  render_views
  before do
    # work around bug in routing testing
    @routes = Lightweight::Engine.routes
  end

  describe 'index' do
    it 'returns a list of available MW Interactives' do
      pending 'Not working this yet'
    end
  end

  describe 'show' do
    it 'is not routable' do
      begin
        get :show, :id => 'foo'
        throw 'should not have been able to route to show'
      rescue
      end
    end
  end

  context 'when the logged-in user is an ordinary user' do
    describe 'interactives' do
      it 'are not editable' do
        pending 'we are not yet ready for this'
      end
    end
  end

  context 'when the logged-in user is an author' do
    context 'and an InteractivePage ID is provided' do
      before do
        @page = Lightweight::InteractivePage.create!()
      end

      describe 'new' do
        it 'automatically creates a new interactive' do
          starting_count = Lightweight::MwInteractive.count()
          join_count = Lightweight::InteractiveItem.count()
          get :new, :page_id => @page.id

          Lightweight::MwInteractive.count().should equal starting_count + 1
          Lightweight::InteractiveItem.count().should equal join_count + 1
        end

        it 'redirects the submitter to the edit page' do
          get :new
          response.should redirect_to("/lightweight/mw_interactives/#{assigns(:interactive).id}/edit")
        end
      end

      describe 'create' do
        it 'creates an empty MW Interactive' do
          post :create
        end

        it 'redirects the submitter to the edit page' do
        end
      end
    end

    describe 'edit' do
      it 'shows a form with values of the MW Interactive filled in' do
      end
    end

    describe 'update' do
      it 'replaces the values of the MW Interactive to match submitted values' do
      end

      it 'returns to the edit page with a message indicating success' do
      end

      it 'returns to the edit page with an error on failure' do
      end
    end

    describe 'destroy' do
      it 'removes the requested MW Interactive from the database' do
        pending 'deleting is not yet specified'
      end
    end
  end
end
