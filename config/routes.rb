Rails.application.routes.draw do
  resources :blogs do
    collection do
      post :confirm
    end
    resources :users, only: [:new, :create]
  end
end
