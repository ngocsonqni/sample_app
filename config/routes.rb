Rails.application.routes.draw do
  get "static_page/home"
  get "static_page/help"
  scope "(:locale)", locale: /en|vi/ do
  end
end
