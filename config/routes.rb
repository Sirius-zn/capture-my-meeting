Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
	root 'site#index'
  
	get '/login', to: 'site#login'
	get '/sign_up', to: 'site#sign_up'

	resources :users
end
