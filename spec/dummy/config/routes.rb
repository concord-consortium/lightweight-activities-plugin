Rails.application.routes.draw do
  mount Lightweight::Engine => "/lightweight"

  namespace :embeddable do
    resources :xhtml, only: [:update]
    resources :open_response, only: [:update]
    resources :multiple_choice do
      member do
        post :add_choice
      end
    end
  end
end
