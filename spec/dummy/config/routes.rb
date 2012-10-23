Rails.application.routes.draw do
  mount Lightweight::Engine => "/lightweight"

  namespace :embeddable do
    resources :xhtmls, only: [:update]
    resources :open_responses, only: [:update]
    resources :multiple_choices do
      member do
        post :add_choice
      end
    end
  end
end
