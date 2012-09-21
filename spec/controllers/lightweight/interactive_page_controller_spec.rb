require 'spec_helper'

describe Lightweight::InteractivePageController do
  render_views
  before do
    # work around bug in routing testing
    @routes = Lightweight::Engine.routes
  end

  describe 'routing' do
    it 'recognizes and generates #show' do
      {:get => "page/3/2"}.should route_to(:controller => 'lightweight/interactive_page', :action => 'show', :id => "3", :offering_id => '2')
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
      offer.save

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

    it 'should not render a form if the activity has no offering' do
      act = Lightweight::LightweightActivity.create!(:name => "Test activity")
      page1 = act.pages.create!(:name => "Page 1", :text => "This is the main activity text.")
      page2 = act.pages.create!(:name => "Page 2", :text => "This is the next activity text.")
      page3 = act.pages.create!(:name => "Page 3", :text => "This is the last activity text.")

      get :show, :id => page1.id

      response.body.should_not match /<form accept-charset="UTF-8" action="\/portal\/offerings/
    end

    it 'should list pages with links to each' do
      # setup
      act = Lightweight::LightweightActivity.create!(:name => "Test activity")
      page1 = act.pages.create!(:name => "Page 1", :text => "This is the main activity text.")
      page2 = act.pages.create!(:name => "Page 2", :text => "This is the next activity text.")
      page3 = act.pages.create!(:name => "Page 3", :text => "This is the last activity text.")

      get :show, :id => page1.id

      response.body.should match /<a[^>]*href="\/lightweight\/page\/#{page1.id}"[^>]*>[^<]*1[^<]*<\/a>/
      response.body.should match /<a[^>]*href="\/lightweight\/page\/#{page2.id}"[^>]*>[^<]*2[^<]*<\/a>/
      response.body.should match /<a[^>]*href="\/lightweight\/page\/#{page3.id}"[^>]*>[^<]*3[^<]*<\/a>/
    end

    it 'should only render the forward navigation link if it is a first page' do
      # setup
      act = Lightweight::LightweightActivity.create!(:name => "Test activity")
      page1 = act.pages.create!(:name => "Page 1", :text => "This is the main activity text.")
      page2 = act.pages.create!(:name => "Page 2", :text => "This is the next activity text.")
      page3 = act.pages.create!(:name => "Page 3", :text => "This is the last activity text.")

      get :show, :id => page1.id

      response.body.should match /<a class='previous disabled'>[^<]*&nbsp;[^<]*<\/a>/
      response.body.should match /<a class='next' href='\/lightweight\/page\/#{page2.id}'>[^<]*&nbsp;[^<]*<\/a>/
    end

    it 'should render both the forward and back navigation links if it is a middle page' do
      # setup
      act = Lightweight::LightweightActivity.create!(:name => "Test activity")
      page1 = act.pages.create!(:name => "Page 1", :text => "This is the main activity text.")
      page2 = act.pages.create!(:name => "Page 2", :text => "This is the next activity text.")
      page3 = act.pages.create!(:name => "Page 3", :text => "This is the last activity text.")

      get :show, :id => page2.id

      response.body.should match /<a class='previous' href='\/lightweight\/page\/#{page1.id}'>[^<]*&nbsp;[^<]*<\/a>/
      response.body.should match /<a class='next' href='\/lightweight\/page\/#{page3.id}'>[^<]*&nbsp;[^<]*<\/a>/
    end

    it 'should only render the back navigation links on the last page' do
      # setup
      act = Lightweight::LightweightActivity.create!(:name => "Test activity")
      page1 = act.pages.create!(:name => "Page 1", :text => "This is the main activity text.")
      page2 = act.pages.create!(:name => "Page 2", :text => "This is the next activity text.")
      page3 = act.pages.create!(:name => "Page 3", :text => "This is the last activity text.")

      get :show, :id => page3.id

      response.body.should match /<a class='previous' href='\/lightweight\/page\/#{page2.id}'>[^<]*&nbsp;[^<]*<\/a>/
      response.body.should match /<a class='next disabled'>[^<]*&nbsp;[^<]*<\/a>/
    end

    it 'should indicate the active page with a DOM class attribute' do
      # setup
      act = Lightweight::LightweightActivity.create!(:name => "Test activity")
      page1 = act.pages.create!(:name => "Page 1", :text => "This is the main activity text.")
      page2 = act.pages.create!(:name => "Page 2", :text => "This is the next activity text.")

      get :show, :id => page1.id

      response.body.should match /<a href="\/lightweight\/page\/#{page1.id}" class="active">1<\/a>/
    end

    it 'should not render pagination links if it is the only page' do
      # setup
      act = Lightweight::LightweightActivity.create!(:name => "Test activity")
      page1 = act.pages.create!(:name => "Page 1", :text => "This is the main activity text.")

      get :show, :id => page1.id

      response.body.should_not match /<a class='prev'>/
      response.body.should_not match /<a class='next'>/
    end

    it 'should include a class value matching the defined theme' do
      # setup
      act = Lightweight::LightweightActivity.create!(:name => "Test activity")
      page1 = act.pages.create!(:name => "Page 1", :text => "This is the main activity text.", :theme => 'theme-string')

      get :show, :id => page1.id

      response.body.should match /<div class='content theme-string'>/
    end

    it 'should display previous answers when viewed again' do
      # setup
      act = Lightweight::LightweightActivity.create!(:name => "Test activity")

      # set up page
      @page = act.pages.create!(:name => "Page 1", :text => "This is the main activity text.")

      # Add embeddables
      @open_response = Embeddable::OpenResponse.create!(:name => "Open Response 1", :prompt => "Why do you think this model is cool?")

      @multiple_choice = Embeddable::MultipleChoice.create!(:name => "Multiple choice 1", :prompt => "What color is chlorophyll?")
      Embeddable::MultipleChoiceChoice.create(:choice => 'Red', :multiple_choice => @multiple_choice)
      Embeddable::MultipleChoiceChoice.create(:choice => 'Green', :multiple_choice => @multiple_choice)
      Embeddable::MultipleChoiceChoice.create(:choice => 'Blue', :multiple_choice => @multiple_choice)

      @page.add_embeddable(@multiple_choice)
      @page.add_embeddable(@open_response)

      @offering = Portal::Offering.create!
      @offering.runnable = act
      @offering.save

      choice = @multiple_choice.choices.last

      @learner = mock_model('Learner', :id => 1, :offering => @offering)
      controller.stub(:setup_portal_student) { mock_model('Learner', :id => 1) }

      # To create a saveable with a learner_id, we need to do it directly - posts to Offering#answer won't work, because it's a stub action which isn't learner-aware.
      saveable_open_response = Saveable::OpenResponse.find_or_create_by_learner_id_and_offering_id_and_open_response_id(1, @offering.id, @open_response.id)
      if saveable_open_response.response_count == 0 || saveable_open_response.answers.last.answer != "This is an OR answer"
        saveable_open_response.answers.create(:answer => "This is an OR answer")
      end

      saveable_mc = Saveable::MultipleChoice.find_or_create_by_learner_id_and_offering_id_and_multiple_choice_id(1, @offering.id, @multiple_choice.id)
      if saveable_mc.answers.empty? || saveable_mc.answers.last.answer != choice
        saveable_mc.answers.create(:choice_id => choice.id)
      end

      get :show, :id => @page.id, :offering_id => @offering.id, :format => 'run_html'

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

    it 'should show sidebar content on pages which have it' do
      # setup
      act = Lightweight::LightweightActivity.create!(:name => "Test activity")
      page1 = act.pages.create!(:name => "Page 1", :text => "This is the main activity text.", :sidebar => '<p>This is sidebar text.</p>')

      get :show, :id => page1.id

      response.body.should match /<div class='sidebar'>\n<p>This is sidebar text\.<\/p>/
    end

    it 'should show related content on the last page' do
      act = Lightweight::LightweightActivity.create!(:name => "Test activity", :related => '<p>This is related content.</p>')
      page1 = act.pages.create!(:name => "Page 1", :text => "This is the main activity text.")

      get :show, :id => page1.id

      response.body.should match /<div class='related'>\n<p>This is related content\.<\/p>/
    end

    it 'should not show related content on pages other than the last page' do
      act = Lightweight::LightweightActivity.create!(:name => "Test activity", :related => '<p>This is related content.</p>')
      page1 = act.pages.create!(:name => "Page 1", :text => "This is the main activity text.")
      page2 = act.pages.create!(:name => "Page 2", :text => "This is the next activity text.")

      get :show, :id => page1.id

      response.body.should_not match /<div class='related'>/
    end
  end
end
