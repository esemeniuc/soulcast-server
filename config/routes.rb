Rails.application.routes.draw do

  resources :devices
  resources :souls
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  post 'echo' => 'echo#reply'
end
