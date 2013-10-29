class SessionsController < ApplicationController

	def new
	end


	def create
		user = User.find_by(email: params[:session][:email].downcase)
		if user && user.authenticate(params[:session][:password])
			sign_in user
			redirect_to '/input'
		else
			flash.now[:notice] = 'Invalid email/password combination!'
			render 'new'
		end
	end

	def destroy
		sign_out
		flash[:notice] = 'You have signed out.'
		redirect_to signin_path
	end

end
