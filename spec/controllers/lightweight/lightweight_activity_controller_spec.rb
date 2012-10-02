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

  describe 'index' do
    context 'when the current user is not an author' do
      it 'should redirect to the home page with an error message' do
      end
    end

    context 'when the current user is an author' do
      it 'should provide a link to create a new Lightweight Investigation on the index page' do
        get :index
        response.body.should match /<a[^>]+href='(\/lightweight\/activities\/)?new'[^>]>/
      end

      it 'should provide a list of authored Lightweight Investigations on the index page' do
        pending "only needed for editing"
        get :index
        response.body.should match /<div[^>]+id="lightweight_activities_list">/
      end
    end
  end

  describe 'new' do
    it 'should provide a form for naming and describing a Lightweight Investigation' do
      pending "Finish index first"
    end

    it 'should create a new Lightweight Investigation when submitted with valid data' do
      pending "Finish index first"
    end

    it 'should return to the form with an error message when submitted with invalid data' do
      pending "Finish index first"
    end
  end

end
