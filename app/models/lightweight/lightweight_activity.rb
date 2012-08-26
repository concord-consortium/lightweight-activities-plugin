module Lightweight
  class LightweightActivity < ActiveRecord::Base
    attr_accessible :name, :publication_status, :user, :pages

    has_many :pages, :foreign_key => 'lightweight_activity_id', :class_name => 'Lightweight::InteractivePage', :order => :position
  end
end
