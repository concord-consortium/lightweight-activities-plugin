Lightweight::Engine.routes.draw do
  get "/activity/:id" => 'lightweight_activity#show', :as => 'lightweight_activity_show', :constraints => {:id => /\d+/}
end
