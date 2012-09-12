class Saveable::OpenResponseAnswer < ActiveRecord::Base
  # This model is cribbed from the portal to support testing of answer persistance within
  # this dummy app. It's not intended to be part of the engine.

  self.table_name = "saveable_open_response_answers"
  attr_accessible :answer

  belongs_to :open_response,  :class_name => 'Saveable::OpenResponse', :counter_cache => :response_count

  acts_as_list :scope => :open_response_id
  
end
