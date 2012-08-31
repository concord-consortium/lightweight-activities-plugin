require 'spec_helper'

describe Lightweight::InteractivePage do
  before :each do
    @valid = {
      :name => "Page",
      :text => "Some text"
    }
    @page = Lightweight::InteractivePage.create!(@valid)
  end

  it 'should have valid attributes' do
    @page.name.should == "Page"
    @page.text.should == "Some text"
  end

  it 'should belong to a lightweight activity' do
    @activity = Lightweight::LightweightActivity.create!(:name => "Activity")

    @page.lightweight_activity = @activity
    @page.save!

    @page.reload

    @page.lightweight_activity.should == @activity
    @activity.pages.size.should == 1
    @activity.pages.first.should == @page
  end

  it 'should have interactives' do
    [3,1,2].each do |i|
      inter = Lightweight::MWInteractive.create!(:name => "inter #{i}", :url => "http://www.concord.org/#{i}")
      @page.add_interactive(inter, i)
    end
    @page.reload

    @page.interactives.size.should == 3
  end

  it 'should have interactives in the correct order' do
    [3,1,2].each do |i|
      inter = Lightweight::MWInteractive.create!(:name => "inter #{i}", :url => "http://www.concord.org/#{i}")
      @page.add_interactive(inter, i)
    end
    @page.reload

    @page.interactives.first.url.should == "http://www.concord.org/1"
    @page.interactives.last.name.should == "inter 3"
  end

  it 'should have embeddables' do
    pending
  end
end
