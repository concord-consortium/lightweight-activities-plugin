module Lightweight
  class QuestionItem < ActiveRecord::Base
    attr_accessible :interactive_page, :position, :question

    belongs_to :interactive_page
    belongs_to :question, :polymorphic => true
  end
end
