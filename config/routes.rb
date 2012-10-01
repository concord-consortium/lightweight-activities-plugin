Lightweight::Engine.routes.draw do
  # HACK: Seems like these should be nested resources of the offering, but that's not really practical
  # with the engine's URL scheme. Either way, we need to be able to optionally specify an offering ID.
  resources :activities, :controller => 'lightweight_activities', :constraints => { :id => /\d+/ } do
    resources :pages, :controller => 'interactive_pages', :constraints => { :id => /\d+/ }
  end
  
  # 'Show' routes including offering_ids
  get "/activities/:id(/:offering_id)" => 'lightweight_activities#show', :as => 'lightweight_activity_show', :constraints => {:id => /\d+/, :offering_id => /\d+/}
  get "/pages/:id(/:offering_id)" => 'interactive_pages#show', :as => 'interactive_page_show', :constraints => { :id => /\d+/, :offering_id => /\d+/ }
  get "/activities/:activity_id/pages/:id(/:offering_id)" => 'interactive_pages#show', :as => 'activity_page_offering_show', :constraints => { :id => /\d+/, :offering_id => /\d+/, :activity_id => /\d+/ }
end
