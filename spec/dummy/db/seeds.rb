# setup a simple, one-page activity
act = Lightweight::LightweightActivity.create!(:name => "Test activity")
page = act.pages.create!(:name => "Page 1", :text => "This is the main activity text.")
interactive = Lightweight::MWInteractive.create!(:name => "MW model", :url => "http://lab.dev.concord.org/examples/interactives/embeddable.html#interactives/oil-and-water-shake.json")
page.add_interactive(interactive)

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

page.add_embeddable(mc1)
page.add_embeddable(or1)
page.add_embeddable(xhtml1)
page.add_embeddable(or2)
page.add_embeddable(mc2)
