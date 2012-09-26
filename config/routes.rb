DotaStock::Application.routes.draw do
  root to: 'heroes#index'
  resources :heroes
end
