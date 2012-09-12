class Saveable::OpenResponse < ActiveRecord::Base
  # This model is cribbed from the portal to support testing of answer persistance within
  # this dummy app. It's not intended to be part of the engine.

  self.table_name = "saveable_open_responses"

  # belongs_to :learner,        :class_name => 'Portal::Learner'
  belongs_to :offering,        :class_name => 'Portal::Offering'
  
  belongs_to :open_response,  :class_name => 'Embeddable::OpenResponse'

  has_many :answers, :order => :position, :class_name => "Saveable::OpenResponseAnswer"

  # attr_accessible :title, :body
  [:prompt, :name].each { |m| delegate m, :to => :open_response, :class_name => 'Embeddable::OpenResponse' }
  
  include Saveable::Saveable
  def answer
    if answered?
      answers.last.answer
    else
      "not answered"
    end
  end
  
  def answered?
    answers.length > 0
  end
end
