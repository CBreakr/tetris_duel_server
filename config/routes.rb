Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  get "/users/ping", to: "users#ping"
  post '/users/login', to: "users#login"
  post '/users/register', to: "users#register"
  post '/users/logout', to: "users#logout"

  get "/all", to: "users#all"

  post "/games", to: "games#create"

  mount ActionCable.server => '/cable'
end
