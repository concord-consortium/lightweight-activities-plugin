require 'spec_helper'

describe Lightweight::MWInteractive do
  before :each do
    @valid = {
      :name => "mw interactive",
      :url  => "http://www.concord.org"
    }
    @interactive = Lightweight::MWInteractive.create!(@valid)
  end

  it 'should have valid attributes' do
    @interactive.name.should == "mw interactive"
    @interactive.url.should  == "http://www.concord.org"
  end

  it 'should be able to associate an interactive page' do
    @page = Lightweight::InteractivePage.create!(:name => "page", :text => "some text")
    @page.add_interactive(@interactive)

    @interactive.reload
    @page.reload

    @interactive.interactive_page.should == @page
  end

end
