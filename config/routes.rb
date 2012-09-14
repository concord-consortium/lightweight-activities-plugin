Lightweight::Engine.routes.draw do
  # HACK: Seems like these should be nested resources of the offering, but that's not really practical
  # with the engine's URL scheme. Either way, we need to be able to optionally specify an offering ID.
  get "/activity/:id(/:offering_id)" => 'lightweight_activity#show', :as => 'lightweight_activity_show', :constraints => {:id => /\d+/, :offering_id => /\d+/}
  get "/page/:id(/:offering_id)" => 'interactive_page#show', :as => 'interactive_page_show', :constraints => {:id => /\d+/, :offering_id => /\d+/}
end
