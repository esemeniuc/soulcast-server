Rails.application.routes.draw do

  resources :devices
  resources :souls
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  get   'nearby/:id', to: 'devices#nearby'
  post  'echo',       to: 'echo#reply'
end
