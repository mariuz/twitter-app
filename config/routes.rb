TwitterApp::Application.routes.draw do
  get 'sessions/callback', :to => 'sessions#callback', :as => 'callback'
  post 'sessions/follow', :to => 'sessions#follow', :as => 'follow'
  get 'sessions/follow', :to => 'sessions#follow', :as => 'follow'
  get 'sessions/unfollow', :to => 'sessions#unfollow', :as => 'unfollow'
  resources :sessions
  root :to => 'sessions#new'
end
