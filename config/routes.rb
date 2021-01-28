Rails.application.routes.draw do
  get "sessions/new"
  get "sessions/create"
  get "sessions/destroy"
  get "/login", to: "sessions#new"
  post "/login", to: "sessions#create"
  get "/logout", to: "sessions#destroy"

  get "static_page/home"
  get "static_page/help"
  get "/signup", to: "users#new"
  post "/signup", to: "users#create"
  resources :sessions, except: %i(new create)
  scope "(:locale)", locale: /en|vi/ do
    resources :users, except: %i(new create)
  end
end

