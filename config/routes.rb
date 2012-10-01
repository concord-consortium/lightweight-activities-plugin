Lightweight::Engine.routes.draw do
  # HACK: Seems like these should be nested resources of the offering, but that's not really practical
  # with the engine's URL scheme. Either way, we need to be able to optionally specify an offering ID.
  resources :activities, :controller => 'lightweight_activities', :constraints => { :id => /\d+/ } do
    resources :pages, :controller => 'interactive_pages', :constraints => { :id => /\d+/ }
  end
  
  # get "/activity/:id(/:offering_id)" => 'lightweight_activity#show', :as => 'lightweight_activity_show', :constraints => {:id => /\d+/, :offering_id => /\d+/}
  # get "/page/:id(/:offering_id)" => 'interactive_page#show', :as => 'interactive_page_show', :constraints => {:id => /\d+/, :offering_id => /\d+/}
end
