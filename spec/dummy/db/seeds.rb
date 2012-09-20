#### Start creation of one activity ####
# Create the activity
act = Lightweight::LightweightActivity.create!(:name => "Test activity")

act.related = "<p>Here are some related links:</p><ul><li><a href='http://google.com'>Google</a></li><li><a href='https://github.com/concord-consortium/lightweight-activities-plugin'>Github repository</a></li></ul>"
act.save

### Page 1 ###
# This creates a page and adds it to the activity.
page1 = act.pages.create!(:name => "Page 1", :text => "This is the main activity text.")
# Creates an interactive
interactive_p1 = Lightweight::MWInteractive.create!(:name => "MW model", :url => "http://lab.dev.concord.org/examples/interactives/embeddable.html#interactives/oil-and-water-shake.json")
# Adds the interactive to the page.
page1.add_interactive(interactive_p1)

## Add embeddables ##
# Create two OpenResponse embeddables
or1 = Embeddable::OpenResponse.create!(:name => "Open Response 1", :prompt => "Why do you think this model is cool?")
or2 = Embeddable::OpenResponse.create!(:name => "Open Response 2", :prompt => "What would you add to it?")

# Create one MultipleChoice embeddable, with choices
mc1 = Embeddable::MultipleChoice.create!(:name => "Multiple choice 1", :prompt => "What color is chlorophyll?")
Embeddable::MultipleChoiceChoice.create(:choice => 'Red', :multiple_choice => mc1)
Embeddable::MultipleChoiceChoice.create(:choice => 'Green', :multiple_choice => mc1)
Embeddable::MultipleChoiceChoice.create(:choice => 'Blue', :multiple_choice => mc1)

# Create another MultipleChoice embeddable, with choices
mc2 = Embeddable::MultipleChoice.create!(:name => "Multiple choice 2", :prompt => "How many protons does Helium have?")
Embeddable::MultipleChoiceChoice.create(:choice => '1', :multiple_choice => mc2)
Embeddable::MultipleChoiceChoice.create(:choice => '2', :multiple_choice => mc2)
Embeddable::MultipleChoiceChoice.create(:choice => '4', :multiple_choice => mc2)
Embeddable::MultipleChoiceChoice.create(:choice => '7', :multiple_choice => mc2)

# Create an (X)HTML embeddable
xhtml1 = Embeddable::Xhtml.create!(:name => "Xhtml 1", :content => "This is some <strong>xhtml</strong> content!")

# Add the five embeddables created above to the page. The order they are added is the order
# they will be displayed: first on top, last on the bottom.
page1.add_embeddable(mc1)
page1.add_embeddable(or1)
page1.add_embeddable(xhtml1)
page1.add_embeddable(or2)
page1.add_embeddable(mc2)

page1.sidebar = "<p>This is first-page sidebar text. Only the first page has sidebar text.</p>"
page1.save
### End Page 1 ###

### page 2 ###
# This creates a page and adds it to the activity.
page2 = act.pages.create!(:name => "Page 2", :theme => 'stack-left', :text => "This is the main activity text. Sometimes, it just needs to be a bit longer.")
# Create another interactive to add to this page. (Interactives can only belong to one page,
# so for the second page we need another new interactive.)
interactive_p2 = Lightweight::MWInteractive.create!(:name => "MW model", :url => "http://lab.dev.concord.org/examples/interactives/embeddable.html#interactives/oil-and-water-shake.json")
# Add the same interactive to the page.
page2.add_interactive(interactive_p2)

## Add embeddables ##
# Create an OpenResponse embeddable
or3 = Embeddable::OpenResponse.create!(:name => "Open Response 1", :prompt => "What does the model shown represent?")

# Create a MultipleChoice embeddable, with three choices
mc3 = Embeddable::MultipleChoice.create!(:name => "Multiple choice 1", :prompt => "Why are some of the circles red?")
Embeddable::MultipleChoiceChoice.create(:choice => 'Red is a pretty color', :multiple_choice => mc3)
Embeddable::MultipleChoiceChoice.create(:choice => 'Because they are dangerous', :multiple_choice => mc3)
Embeddable::MultipleChoiceChoice.create(:choice => 'Because they are angry', :multiple_choice => mc3)

# Create an (X)HTML embeddable.
xhtml2 = Embeddable::Xhtml.create!(:name => "Xhtml 1", :content => "This is some <strong>xhtml</strong> content!")

# Add the three embeddables to the page, in order.
page2.add_embeddable(xhtml2)
page2.add_embeddable(mc3)
page2.add_embeddable(or3)
### End Page 2 ###

### page 3 ###
# This creates a page and adds it to the activity.
page3 = act.pages.create!(:name => "Page 3", :text => "This is the last page of the activity! I hope you've enjoyed your time today.")
# Create another interactive to add to this page.
interactive_p3 = Lightweight::MWInteractive.create!(:name => "MW model", :url => "http://lab.dev.concord.org/examples/interactives/embeddable.html#interactives/oil-and-water-shake.json")
page3.add_interactive(interactive_p3)

## Add embeddables ##
# Create an OpenResponse embeddable
or4 = Embeddable::OpenResponse.create!(:name => "Open Response 1", :prompt => "What did you think of this activity?")

# Create three (X)HTML embeddables
xhtml3 = Embeddable::Xhtml.create!(:name => "Xhtml 1", :content => "I love adding text to these things.")
xhtml4 = Embeddable::Xhtml.create!(:name => "Xhtml 1", :content => "It's so much fun!")
xhtml5 = Embeddable::Xhtml.create!(:name => "Xhtml 1", :content => "Good job! You're all done now.")

# Add the four embeddables to the page, in order.
page3.add_embeddable(xhtml3)
page3.add_embeddable(xhtml4)
page3.add_embeddable(or4)
page3.add_embeddable(xhtml5)
### End Page 3 ###

### Create an Offering ###
# We need this in the dummy in order to save answers to the questions. Strictly
# speaking we don't need them for styling but there may be errors if there isn't one.

# Create the offering.
offer1 = Portal::Offering.create!
# Make this activity the "runnable" for the offering.
offer1.runnable = act
# Save the offering.
offer1.save

#### End Activity Creation ####

#### Activity 2 ####
act_boiling_point = Lightweight::LightweightActivity.create!(:name => "Boiling point activity")

### Page 1 ###
# This creates a page and adds it to the activity.
page_1_boiling_point = act_boiling_point.pages.create!(:name => "Page 1", :theme => 'full', :text => "All molecules attract to each other through forces called \"intermolecular attractions.\" The temperature at which many substances boil is determined by intermolecular attractions.")

## Add embeddables ##
# Create an (X)HTML embeddable.
xhtml1 = Embeddable::Xhtml.create!(:name => "Xhtml 1", :content => "<p>This is the XHTML embeddable. It should come before the open response.</p>")

# Create an OpenResponse embeddable
or1 = Embeddable::OpenResponse.create!(:name => "Open Response One", :prompt => "How, other than color, are polar and non-polar molecules different? This should be after the HTML embeddable.")

# Add the embeddables created above to the page. The order they are added is the order
# they will be displayed: first on top, last on the bottom.
page_1_boiling_point.add_embeddable(xhtml1)
page_1_boiling_point.add_embeddable(or1)
page_1_boiling_point.sidebar = "<p>This is sidebar content.</p>"
page_1_boiling_point.save
### End Page 1 ###