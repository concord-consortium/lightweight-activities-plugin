require 'spec_helper'

describe Lightweight::InteractivePageController do
  render_views
  before do
    # work around bug in routing testing
    @routes = Lightweight::Engine.routes
  end

  describe 'routing' do
    it 'recognizes and generates #show' do
      {:get => "page/3"}.should route_to(:controller => 'lightweight/interactive_page', :action => 'show', :id => "3")
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
      rescue ActionController::RoutingError
      rescue ActiveRecord::RecordNotFound
      end
    end

    it 'should render the page if it exists' do
      # setup
      act = Lightweight::LightweightActivity.create!(:name => "Test activity")

      # Add the offering
      offer = Portal::Offering.create!
      offer.runnable = act

      # set up page
      page1 = act.pages.create!(:name => "Page 1", :text => "This is the main activity text.")
      interactive = Lightweight::MWInteractive.create!(:name => "MW model", :url => "http://google.com")
      page1.add_interactive(interactive)

      # Add embeddables
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

      xhtml1 = Embeddable::Xhtml.create!(:name => "Xhtml 1", :content => "This is some <strong>xhtml</strong> content!")

      page1.add_embeddable(mc1)
      page1.add_embeddable(or1)
      page1.add_embeddable(xhtml1)
      page1.add_embeddable(or2)
      page1.add_embeddable(mc2)

      # get the rendering
      get :show, :id => act.id

      # verify the page is as expected
      response.body.should match /<iframe[^>]*src=['"]http:\/\/google.com['"]/m
      response.body.should match /What color is chlorophyll\?/m
      response.body.should match /Why do you think this model is cool\?/m
      response.body.should match /What would you add to it\?/m
      response.body.should match /How many protons does Helium have\?/m
      response.body.should match /This is some <strong>xhtml<\/strong> content!/m
      response.body.should match /<form accept-charset="UTF-8" action="\/portal\/offerings\/#{offer.id}\/answers" method="post">/

    end

    it 'should only render the forward navigation link if it is a first page' do
      # setup
      act = Lightweight::LightweightActivity.create!(:name => "Test activity")
      page1 = act.pages.create!(:name => "Page 1", :text => "This is the main activity text.")
      page2 = act.pages.create!(:name => "Page 2", :text => "This is the next activity text.")
      page3 = act.pages.create!(:name => "Page 3", :text => "This is the last activity text.")

      get :show, :id => page1.id

      response.body.should match /<div id='forward-page'>[^<]*<a href="\/lightweight\/page\/#{page2.id}">/
      response.body.should match /<div id='back-page'>[^<]*<\/div>/
    end

    it 'should render both the forward and back navigation links if it is a middle page' do
      # setup
      act = Lightweight::LightweightActivity.create!(:name => "Test activity")
      page1 = act.pages.create!(:name => "Page 1", :text => "This is the main activity text.")
      page2 = act.pages.create!(:name => "Page 2", :text => "This is the next activity text.")
      page3 = act.pages.create!(:name => "Page 3", :text => "This is the last activity text.")

      get :show, :id => page2.id

      response.body.should match /<div id='forward-page'>[^<]*<a href="\/lightweight\/page\/#{page3.id}">/
      response.body.should match /<div id='back-page'>[^<]*<a href="\/lightweight\/page\/#{page1.id}">/
    end

    it 'should only render the back navigation links on the last page' do
      # setup
      act = Lightweight::LightweightActivity.create!(:name => "Test activity")
      page1 = act.pages.create!(:name => "Page 1", :text => "This is the main activity text.")
      page2 = act.pages.create!(:name => "Page 2", :text => "This is the next activity text.")
      page3 = act.pages.create!(:name => "Page 3", :text => "This is the last activity text.")

      get :show, :id => page3.id

      response.body.should match /<div id='forward-page'>[^<]*<\/div>/
      response.body.should match /<div id='back-page'>[^<]*<a href="\/lightweight\/page\/#{page2.id}">/
    end

    it 'should not render either navigation link if it is the only page' do
      # setup
      act = Lightweight::LightweightActivity.create!(:name => "Test activity")
      page1 = act.pages.create!(:name => "Page 1", :text => "This is the main activity text.")

      get :show, :id => page1.id

      response.body.should match /<div id='forward-page'>[^<]*<\/div>/
      response.body.should match /<div id='back-page'>[^<]*<\/div>/
    end

    it 'should include a class value matching the defined theme' do
      # setup
      act = Lightweight::LightweightActivity.create!(:name => "Test activity")
      page1 = act.pages.create!(:name => "Page 1", :text => "This is the main activity text.", :theme => 'theme-string')

      get :show, :id => page1.id

      response.body.should match /<div class='content theme-string'>/
    end
    
    it 'should display previous answers when viewed again' do
      # @clazz.should_receive(:is_student?).and_return(true)

      mc_sym = "embeddable__multiple_choice_#{@multiple_choice.id}"
      or_sym = "embeddable__open_response_#{@open_response.id}"

      choice = @multiple_choice.choices.last
      answers = {mc_sym => "embeddable__multiple_choice_choice_#{choice.id}", or_sym => "This is an OR answer"}

      post :answers, :id => @offering.id, :questions => answers

      get :show, :id => @offering.id, :format => 'run_html'

      or_regex = /<textarea.*?name='questions\[embeddable__open_response_(\d+)\].*?>[^<]*This is an OR answer[^<]*<\/textarea>/m
      response.body.should =~ or_regex

      mc_regex = /<input.*?checked.*?name='questions\[embeddable__multiple_choice_(\d+)\]'.*?type='radio'.*?value='embeddable__multiple_choice_choice_#{choice.id}'/
      response.body.should =~ mc_regex
    end

    it 'should disable the submit button when there is no learner' do
      pending('Not sure this is required')
      controller.stub!(:setup_portal_student).and_return(nil)
      get :show, :id => @offering.id, :format => 'run_html'
      response.body.should =~ /<input.*class='disabled'.*type='submit'/
    end
  end
end
