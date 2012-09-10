# setup a simple, one-page activity
act = Lightweight::LightweightActivity.create!(:name => "Test activity")

# page 1
page1 = act.pages.create!(:name => "Page 1", :text => "This is the main activity text.")
interactive = Lightweight::MWInteractive.create!(:name => "MW model", :url => "http://lab.dev.concord.org/examples/interactives/embeddable.html#interactives/oil-and-water-shake.json")
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

# page 2
page2 = act.pages.create!(:name => "Page 2", :text => "This is the main activity text. Sometimes, it just needs to be a bit longer.")
interactive = Lightweight::MWInteractive.create!(:name => "MW model", :url => "http://lab.dev.concord.org/examples/interactives/embeddable.html#interactives/oil-and-water-shake.json")
page2.add_interactive(interactive)

# Add embeddables
or1 = Embeddable::OpenResponse.create!(:name => "Open Response 1", :prompt => "What does the model shown represent?")

mc1 = Embeddable::MultipleChoice.create!(:name => "Multiple choice 1", :prompt => "Why are some of the circles red?")
Embeddable::MultipleChoiceChoice.create(:choice => 'Red is a pretty color', :multiple_choice => mc1)
Embeddable::MultipleChoiceChoice.create(:choice => 'Because they are dangerous', :multiple_choice => mc1)
Embeddable::MultipleChoiceChoice.create(:choice => 'Because they are angry', :multiple_choice => mc1)

xhtml1 = Embeddable::Xhtml.create!(:name => "Xhtml 1", :content => "This is some <strong>xhtml</strong> content!")

page2.add_embeddable(xhtml1)
page2.add_embeddable(mc1)
page2.add_embeddable(or1)

# page 3
page3 = act.pages.create!(:name => "Page 3", :text => "This is the last page of the activity! I hope you've enjoyed your time today.")
interactive = Lightweight::MWInteractive.create!(:name => "MW model", :url => "http://lab.dev.concord.org/examples/interactives/embeddable.html#interactives/oil-and-water-shake.json")
page3.add_interactive(interactive)

# Add embeddables
or1 = Embeddable::OpenResponse.create!(:name => "Open Response 1", :prompt => "What did you think of this activity?")
xhtml1 = Embeddable::Xhtml.create!(:name => "Xhtml 1", :content => "I love adding text to these things.")
xhtml2 = Embeddable::Xhtml.create!(:name => "Xhtml 1", :content => "It's so much fun!")
xhtml3 = Embeddable::Xhtml.create!(:name => "Xhtml 1", :content => "Good job! You're all done now.")

page3.add_embeddable(xhtml1)
page3.add_embeddable(xhtml2)
page3.add_embeddable(or1)
page3.add_embeddable(xhtml3)
