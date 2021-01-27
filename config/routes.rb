Rails.application.routes.draw do
  get "static_page/home"
  get "static_page/help"
  get "/signup", to: "users#new"
  post "/signup", to: "users#create"
  # resources :users, only: %i(new create)
  scope "(:locale)", locale: /en|vi/ do
    resources :users, except: %i(new create)
  end
end
