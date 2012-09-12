class Saveable::MultipleChoiceAnswer < ActiveRecord::Base
  # This model is cribbed from the portal to support testing of answer persistance within
  # this dummy app. It's not intended to be part of the engine.

  self.table_name = "saveable_multiple_choice_answers"
  attr_accessible :choice_id

  belongs_to :multiple_choice,  :class_name => 'Saveable::MultipleChoice', :counter_cache => :response_count
  # belongs_to :bundle_content, :class_name => 'Dataservice::BundleContent'
  
  belongs_to :choice, :class_name => 'Embeddable::MultipleChoiceChoice'

  acts_as_list :scope => :multiple_choice_id
  
  def answer
    if choice
      choice.choice
    else
      "not answered"
    end
  end
  
  def answered_correctly?
    if choice
      choice.is_correct
    else
      false
    end
  end
end
