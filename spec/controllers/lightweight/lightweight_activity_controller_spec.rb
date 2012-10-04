require 'spec_helper'

describe Lightweight::LightweightActivitiesController do
  render_views
  before do
    # work around bug in routing testing
    @routes = Lightweight::Engine.routes
  end

  describe 'routing' do
    it 'recognizes and generates #show' do
      {:get => "activities/3"}.should route_to(:controller => 'lightweight/lightweight_activities', :action => 'show', :id => "3")
    end
  end

  describe 'show' do
    it 'should not route when id is not valid' do
      begin
        get :show, :id => 'foo'
        throw "Should not have been able to route with id='foo'"
      rescue ActionController::RoutingError
      end
    end

    it 'should render 404 when the activity does not exist' do
      begin
        get :show, :id => 34
      rescue ActiveRecord::RecordNotFound
      end
    end

    it 'should render the activity if it exists' do
      # setup
      act = Lightweight::LightweightActivity.create!(:name => "Test activity")
      page = act.pages.create!(:name => "Page 1", :text => "This is the main activity text.")

      # get the rendering
      get :show, :id => act.id

      response.should redirect_to activity_page_url(page)
    end
  end

  context 'when the current user is not an author' do
    before do
      # TODO: Better mocks to reflect the differences between anonymous and Author users
      controller.stub(:current_user, mock_model('User', :anonymous => true))
    end

    it 'should redirect to the home page with an error message' do
      pending "Access control"
      # GET Requests to index, new, edit
      # PUT and POST requests (create, update)
      # DELETE requests
    end
  end

  context 'when the current user is an author' do
    before do
      # TODO: Better mocks to reflect the differences between anonymous and Author users
      controller.stub(:current_user, mock_model('User', :has_role? => true))
    end

    describe 'index' do
      it 'should provide a link to create a new Lightweight Activity on the index page' do
        get :index
        response.body.should match /<a[^>]+href="\/lightweight\/activities\/new"[^>]*>/
      end

      it 'should provide a list of authored Lightweight Activities on the index page' do
        pending "only needed for editing"
        get :index
        response.body.should match /<div[^>]+id="lightweight_activities_list">/
      end
    end

    describe 'new' do

      it 'should provide a form for naming and describing a Lightweight Activity' do
        get :new
        response.body.should match /<form[^<]+action="\/lightweight\/activities"[^<]+method="post"[^<]*>/
        response.body.should match /<input[^<]+id="lightweight_activity_name"[^<]+name="lightweight_activity\[name\]"[^<]+type="text"[^<]*\/>/
        response.body.should match /<textarea[^<]+id="lightweight_activity_description"[^<]+name="lightweight_activity\[description\]"[^<]*>[^<]*<\/textarea>/
      end

      it 'should create a new Lightweight Investigation when submitted with valid data' do
        pending "Finish index first"
      end

      it 'should return to the form with an error message when submitted with invalid data' do
        pending "Finish index first"
      end
    end
  end
end
