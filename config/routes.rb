Lightweight::Engine.routes.draw do
  get "/activity/:id" => 'lightweight_activity#show', :as => 'lightweight_activity_show', :constraints => {:id => /\d+/}
  get "/page/:id" => 'interactive_page#show', :as => 'interactive_page_show', :constraints => {:id => /\d+/}
end
