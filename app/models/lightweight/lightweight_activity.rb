module Lightweight
  class LightweightActivity < ActiveRecord::Base
    attr_accessible :name, :publication_status, :user, :pages, :related

    has_many :pages, :foreign_key => 'lightweight_activity_id', :class_name => 'Lightweight::InteractivePage', :order => :position

    has_many :offerings, :dependent => :destroy, :as => :runnable, :class_name => "Portal::Offering"
  end
end
