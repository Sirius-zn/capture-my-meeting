class SessionsController < ApplicationController
	def new
	end

	def create
		user = User.find_by(:email => params[:sessions][:email].downcase)
		if user && user.authenticate(params[:sessions][:password])
			# Login
			log_in user
			redirect_to root_url 
		else
			# Output Error
			flash.now[:danger] = 'Invalid email/password combination'
			@msg = "Invalid Credentials"
			render 'new'
		end
	end

	def destroy
		log_out
		redirect_to root_url
	end
end
