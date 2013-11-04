class UsersController < ApplicationController
  before_action :signed_in_user,  only: [:show, :edit, :update]
  before_action :correct_user,    only: [:show, :edit, :update]

	def show
		@user = User.find(params[:id])
	end

	def new
		@user = User.new
  end

 	def create
 		@user = User.new(user_params)
 		if @user.save

#      user = User.find_by_email(params[:email])
#      user.send_password_reset if user
#      redirect_to signin_path, :notice => "Email sent with password reset instructions."

#      UserMailer.new_user_info(@user).deliver
 
      @user.send_new_user_info
      
 			sign_in @user
      flash[:notice] = 'Welcome to Gulch Solutions!'
      redirect_to '/input'
 		else	
      render 'new'
 		end
 	end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update_attributes(user_params)
      flash[:success] = "Profile updated"
      redirect_to @user
    else
      render 'edit'
    end
  end
  

  private

  	def user_params
  		params.require(:user).permit(:first_name, :last_name, :email,
                    :phone, :company, :address, :city, :state, :zip,
  									:password, :password_confirmation)
  	end

    # Before filters

    def correct_user
      @user = User.find(params[:id])
      redirect_to(signin_path) unless current_user?(@user)
    end

end
