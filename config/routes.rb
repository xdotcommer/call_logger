Rails.application.routes.draw do
  resources :calls, only: [:index, :create] do
    collection do
      get :last_call_time
    end
  end
end
