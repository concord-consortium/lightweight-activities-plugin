class Portal::Offering < ActiveRecord::Base
  # This model is cribbed from the portal to support testing of answer persistance within
  # this dummy app. It's not intended to be part of the engine.

  self.table_name = :portal_offerings

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

end
