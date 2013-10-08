class UsersController < ApplicationController

	def show
		@user = User.find(params[:id])
	end

	def new
		@user = User.new
  	end

 	def create
 		@user = User.new(user_params)
 		if @user.save
 			sign_in @user
      flash[:sucess] = "Welcome to Gulch Solutions!"
 			redirect_to '/input'
 		else
 			render 'new'
 		end
 	end

  	def login
  	end

  	private

  		def user_params
  			params.require(:user).permit(:first_name, :last_name, :email,
  										:password, :password_confirmation)
  		end

end
