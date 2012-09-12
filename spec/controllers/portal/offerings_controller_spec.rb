require 'spec_helper'

describe Portal::OfferingsController do
  # Borrowed from the main portal code to test that the lightweight engine works as expected.
  # http://stackoverflow.com/q/6040479/306084
  before(:each) do
    request.env["HTTP_REFERER"] = "where_i_came_from"
  end

  it 'should create saveables when the form is submitted' do
    # @clazz.should_receive(:is_student?).and_return(true)
    # setup
    act = Lightweight::LightweightActivity.create!(:name => "Test activity")

    # Add the offering
    # offer = Portal::Offering.create!
    # offer.runnable = act
    # 
    # set up page
    @runnable = act.pages.create!(:name => "Page 1", :text => "This is the main activity text.")

    # Add embeddables
    @open_response = Embeddable::OpenResponse.create!(:name => "Open Response 1", :prompt => "Why do you think this model is cool?")

    @multiple_choice = Embeddable::MultipleChoice.create!(:name => "Multiple choice 1", :prompt => "What color is chlorophyll?")
    Embeddable::MultipleChoiceChoice.create(:choice => 'Red', :multiple_choice => @multiple_choice)
    Embeddable::MultipleChoiceChoice.create(:choice => 'Green', :multiple_choice => @multiple_choice)
    Embeddable::MultipleChoiceChoice.create(:choice => 'Blue', :multiple_choice => @multiple_choice)

    @runnable.add_embeddable(@multiple_choice)
    @runnable.add_embeddable(@open_response)
    
    @offering = Portal::Offering.create!
    @offering.runnable = @runnable
    @offering.save

    mc_sym = "embeddable__multiple_choice_#{@multiple_choice.id}"
    or_sym = "embeddable__open_response_#{@open_response.id}"

    choice = @multiple_choice.choices.last
    answers = {mc_sym => "embeddable__multiple_choice_choice_#{choice.id}", or_sym => "This is an OR answer"}

    or_saveables_size = Saveable::OpenResponse.find(:all).size
    mc_saveables_size = Saveable::MultipleChoice.find(:all).size

    post :answers, :id => @offering.id, :questions => answers

    or_saveables = Saveable::OpenResponse.find(:all)
    or_saveables.size.should == (or_saveables_size + 1)
    or_saveables.last.answer.should == "This is an OR answer"

    mc_saveables = Saveable::MultipleChoice.find(:all)
    mc_saveables.size.should == (mc_saveables_size + 1)
    mc_saveables.last.answer.should == choice.choice
  end

  it 'should display previous answers when view again' do
    pending('First it needs to create savables')
    @clazz.should_receive(:is_student?).and_return(true)

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