module Lightweight
  class InteractivePage < ActiveRecord::Base
    attr_accessible :lightweight_activity, :name, :position, :user, :text

    belongs_to :lightweight_activity, :class_name => 'Lightweight::LightweightActivity'

    has_many :interactive_items, :order => :position

    def interactives
      self.interactive_items.collect{|ii| ii.interactive}
    end

    has_many :question_items, :order => :position
    def questions
      self.question_items.collect{|qi| qi.question}
    end

    def add_interactive(interactive, position = nil)
      Lightweight::InteractiveItem.create!(:interactive_page => self, :interactive => interactive, :position => (position || self.interactive_items.size))
    end

    def add_question(question, position = nil)
      Lightweight::QuestionItem.create!(:interactive_page => self, :question => question, :position => (position || self.question_items.size))
    end
  end
end
