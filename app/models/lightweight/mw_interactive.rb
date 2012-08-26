module Lightweight
  class MWInteractive < ActiveRecord::Base
    attr_accessible :name, :url, :user

    has_one :interactive_item, :as => :interactive
    has_one :interactive_page, :through => :interactive_item
  end
end
