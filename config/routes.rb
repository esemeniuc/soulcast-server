Rails.application.routes.draw do

  resources :histories
  resources :blocks
  resources :souls
  resources :devices
  root 'website#index' #for production mode, show the homepage

  get   'test',       to: 'test#index'
  post  'test',       to: 'test#sendToEveryone'

  get   'nearby/:id', to: 'devices#nearby'
  get   'history/:id', to: 'histories#device_history'

  post  'echo',       to: 'echo#reply'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

end
