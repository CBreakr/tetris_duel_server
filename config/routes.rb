Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  mount ActionCable.server => '/cable'

  get "/users/ping", to: "users#ping"
  post '/users/login', to: "users#login"
  post '/users/register', to: "users#register"
  post '/users/logout', to: "users#logout"

  get "/users/available", to: "users#available"
  patch "/users/:id/enter_lobby", to: "users#enter_lobby"

  # just for testing purposes
  get "/all", to: "users#all"

  post "/games", to: "games#create"  
  
  get "/matches/active", to: "matches#active"
  post "/matches/issue_challenge", to: "matches#issue_challenge"
  post "/matches/reject_challenge", to: "matches#reject_challenge"
  post "/matches/accept_challenge", to: "matches#accept_challenge"
  patch "/matches/:id", to: "matches#update"
  patch "/matches/:id/concede", to: "matches#concede"
  patch "/matches/:id/match_lost", to: "matches#match_lost"
  patch "/matches/:id/accept_handshake", to: "matches#accept_handshake"

end
