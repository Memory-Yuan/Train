class UsersController < ApplicationController
    
  def show
    @user = User.find(params[:id])
    @page_title = @user.name
  end
  
  def new
    @user = User.new
  end
  
  def create
      @user = User.new(user_params)
      if @user.save
          flash[:success] = "Welcome to the Train App!"
          redirect_to @user
#          redirect_to user_url(@user)
      else
          render 'new'
      end
  end
  
  private
  
    def user_params
  #      params.require(:user).permit!
      params.require(:user).permit(:name, :email, :password, :password_confirmation)
    end
end