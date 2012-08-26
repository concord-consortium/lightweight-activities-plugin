require 'spec_helper'

describe Lightweight::LightweightActivityController do
  render_views
  before do
    # work around bug in routing testing
    @routes = Lightweight::Engine.routes
  end

  describe 'routing' do
    it 'recognizes and generates #show' do
      {:get => "activity/3"}.should route_to(:controller => 'lightweight/lightweight_activity', :action => 'show', :id => "3")
    end
  end

  describe 'show' do
    it 'should not route when id is not valid' do
      begin
        get :activity, :id => 'foo'
        throw "Should not have been able to route with id='foo'"
      rescue ActionController::RoutingError
      end
    end

    it 'should render 404 when the activity does not exist' do
      begin
        get :activity, :id => 34
      rescue ActionController::RoutingError
      end
    end

    it 'should render the activity if it exists' do
      # setup
      act = Lightweight::LightweightActivity.create!(:name => "Test activity")
      page = act.pages.create!(:name => "Page 1", :text => "This is the main activity text.")
      interactive = Lightweight::MWInteractive.create!(:name => "MW model", :url => "http://google.com")
      Lightweight::InteractiveItem.create!(:interactive_page => page, :interactive => interactive)

      # Add questions
      or1 = Embeddable::OpenResponse.create!(:name => "Open Response 1", :prompt => "Why do you think this model is cool?")
      or2 = Embeddable::OpenResponse.create!(:name => "Open Response 2", :prompt => "What would you add to it?")

      mc1 = Embeddable::MultipleChoice.create!(:name => "Multiple choice 1", :prompt => "What color is chlorophyll?")
      Embeddable::MultipleChoiceChoice.create(:choice => 'Red', :multiple_choice => mc1)
      Embeddable::MultipleChoiceChoice.create(:choice => 'Green', :multiple_choice => mc1)
      Embeddable::MultipleChoiceChoice.create(:choice => 'Blue', :multiple_choice => mc1)

      mc2 = Embeddable::MultipleChoice.create!(:name => "Multiple choice 2", :prompt => "How many protons does Helium have?")
      Embeddable::MultipleChoiceChoice.create(:choice => '1', :multiple_choice => mc2)
      Embeddable::MultipleChoiceChoice.create(:choice => '2', :multiple_choice => mc2)
      Embeddable::MultipleChoiceChoice.create(:choice => '4', :multiple_choice => mc2)
      Embeddable::MultipleChoiceChoice.create(:choice => '7', :multiple_choice => mc2)

      Lightweight::QuestionItem.create!(:interactive_page => page, :question => mc1)
      Lightweight::QuestionItem.create!(:interactive_page => page, :question => or1)
      Lightweight::QuestionItem.create!(:interactive_page => page, :question => or2)
      Lightweight::QuestionItem.create!(:interactive_page => page, :question => mc2)

      # get the rendering
      get :show, :id => act.id

      # verify the page is as expected
      response.body.should match /<iframe[^>]*src=['"]http:\/\/google.com['"]/m
      response.body.should match /What color is chlorophyll\?/m
      response.body.should match /Why do you think this model is cool\?/m
      response.body.should match /What would you add to it\?/m
      response.body.should match /How many protons does Helium have\?/m
    end
  end
end
