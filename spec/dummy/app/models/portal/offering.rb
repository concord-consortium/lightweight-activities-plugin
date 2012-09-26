class Portal::Offering < ActiveRecord::Base
  # This model is cribbed from the portal to support testing of answer persistance within
  # this dummy app. It's not intended to be part of the engine.

  self.table_name = :portal_offerings

  belongs_to :runnable, :polymorphic => true, :counter_cache => "offerings_count"

  has_many :learners, :dependent => :destroy, :class_name => "Portal::Learner", :foreign_key => "offering_id"

  has_many :open_responses, :class_name => "Saveable::OpenResponse", :foreign_key => "offering_id" do
    def answered
      find(:all).select { |question| question.answered? }
    end
  end

  has_many :multiple_choices, :class_name => "Saveable::MultipleChoice", :foreign_key => "offering_id" do
    def answered
      find(:all).select { |question| question.answered? }
    end
    def answered_correctly
      find(:all).select { |question| question.answered? }.select{ |item| item.answered_correctly? }
    end
  end

  attr_reader :saveable_objects

  def saveables
    multiple_choices + open_responses
  end

  def find_or_create_learner(student)
    # This only works because this is a dummy model.
    Portal::Learner.find(:first)
  end

end
