Rails.application.routes.draw do
  root 'home#index'
  get 'home/index'

  get '/poll/:id', to: 'poll#show'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
