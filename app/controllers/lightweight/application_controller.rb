module Lightweight
  class ApplicationController < ActionController::Base
    include AuthenticatedSystem unless !defined? AuthenticatedSystem
    helper :all
  end
end
