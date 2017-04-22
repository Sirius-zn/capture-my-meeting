Rails.application.routes.draw do
  get 'sessions/new'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
	root 'site#index'

	get '/login', to: 'sessions#new'
	post '/login', to: 'sessions#create'
	delete '/logout', to: 'sessions#destroy'

	get '/sign_up', to: 'site#sign_up'
    post '/meetings/join', to: 'meetings#join'

	resources :users
    resources :meetings
end
