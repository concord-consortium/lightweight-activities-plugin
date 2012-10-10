Lightweight::Engine.routes.draw do
  # HACK: Seems like these should be nested resources of the offering, but that's not really practical
  # with the engine's URL scheme. Either way, we need to be able to optionally specify an offering ID.
  resources :activities, :controller => 'lightweight_activities', :constraints => { :id => /\d+/ } do
    resources :pages, :controller => 'interactive_pages', :constraints => { :id => /\d+/ }
  end
  
  # These don't need index or show pages - though there might be something to be said for an
  # index .xml file as a feed for select menus - but they need create-update-delete.
  resources :mw_interactives, :controller => 'mw_interactives', :constraints => { :id => /\d+/ }, :except => :show

  # This is so we can build the InteractiveItem at the same time as the Interactive
  resources :pages, :controller => 'interactive_pages', :constraints => { :id => /\d+/ }, :only => [:show] do
    resources :mw_interactives, :controller => 'mw_interactives', :constraints => { :id => /\d+/ }, :except => :show
  end

  # 'Show' routes including offering_ids
  get "/activities/:id(/:offering_id)" => 'lightweight_activities#show', :as => 'lightweight_activity_show', :constraints => {:id => /\d+/, :offering_id => /\d+/}
  get "/pages/:id(/:offering_id)" => 'interactive_pages#show', :as => 'interactive_page_show', :constraints => { :id => /\d+/, :offering_id => /\d+/ }
  get "/activities/:activity_id/pages/:id(/:offering_id)" => 'interactive_pages#show', :as => 'activity_page_offering_show', :constraints => { :id => /\d+/, :offering_id => /\d+/, :activity_id => /\d+/ }
end
