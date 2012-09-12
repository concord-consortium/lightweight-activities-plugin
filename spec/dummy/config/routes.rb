Rails.application.routes.draw do
  mount Lightweight::Engine => "/lightweight"

  namespace :portal do
    resources :offerings do
      member do
        post :answers
      end
    end
  end
end
