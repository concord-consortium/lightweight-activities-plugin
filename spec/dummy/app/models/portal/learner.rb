class Portal::Learner < ActiveRecord::Base
  self.table_name = :portal_learners

  belongs_to :offering, :class_name => "Portal::Offering", :foreign_key => "offering_id"

end