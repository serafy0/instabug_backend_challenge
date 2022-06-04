Rails.application.routes.draw do
  resources :apps do
    resources :chats do
      resources :messages do
        post 'search', on: :collection
      end
    end
  end

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
