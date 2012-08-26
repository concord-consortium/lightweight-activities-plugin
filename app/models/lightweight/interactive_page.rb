module Lightweight
  class InteractivePage < ActiveRecord::Base
    attr_accessible :lightweight_activity, :name, :position, :user, :text

    belongs_to :lightweight_activity, :class_name => 'Lightweight::LightweightActivity'

    has_many :interactive_items, :order => :position

    def interactives
      self.interactive_items.collect{|ii| ii.interactive}
    end

    # has_many :questions,    :polymorphic => true, :order => :position
    #
    #
    def add_interactive(interactive, position = nil)
      Lightweight::InteractiveItem.create!(:interactive_page => self, :interactive => interactive, :position => (position || self.interactive_items.size))
    end
  end
end
