Rails.application.routes.draw do

  root 'website#index' #for production mode, show the homepage
  resources :devices
  resources :souls

  get   'nearby/:id', to: 'devices#nearby'
  post  'echo',       to: 'echo#reply'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

end
