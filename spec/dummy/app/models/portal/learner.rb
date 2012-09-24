class Portal::Learner < ActiveRecord::Base
  belongs_to :offering, :class_name => "Portal::Offering", :foreign_key => "offering_id"

end