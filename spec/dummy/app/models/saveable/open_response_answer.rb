class Saveable::OpenResponseAnswer < ActiveRecord::Base
  # attr_accessible :title, :body
  self.table_name = "saveable_open_response_answers"

  belongs_to :open_response,  :class_name => 'Saveable::OpenResponse', :counter_cache => :response_count

  acts_as_list :scope => :open_response_id
  
end
