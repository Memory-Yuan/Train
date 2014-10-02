class UsersController < ApplicationController
  before_action :set_user,          only: [:show, :edit, :update, :destroy, :correct_user]
  before_action :signed_in_user,    only: [:index, :edit, :update]
  before_action :correct_user,      only: [:edit, :update]
  before_action :admin_user,        only: :destroy
  before_action :signed_in_needless_togo, only: [:new, :create]
    
    def index
        @page_title = "All users"
        @users = User.paginate(page: params[:page]) #默認一頁30個
    end
  
  def show
    @page_title = @user.name
    @microposts = @user.microposts.paginate(page: params[:page])
  end
  
  def new
    @user = User.new
    @page_title = "Sign up"
  end
  
  def create
      @user = User.new(user_params)
      if @user.save
          sign_in @user
          flash[:success] = "Welcome to the Train App!"
          redirect_to @user     #redirect_to user_url(@user)
      else
          render 'new'
      end
  end
  
  def edit
      @page_title = "Edit user"
  end
  
  def update
      if @user.update_attributes(user_params)
          flash[:success] = "Profile updated"
          redirect_to @user
      else
          render 'edit'
      end
  end
  
  def destroy
      if current_user?(@user)
          flash[:danger] = "You kill yourself!"
          redirect_to users_url
      elsif @user.destroy
          flash[:success] = "User destroyed."
          redirect_to users_url
      end
  end
  
  def following
      @page_title = "Following"
      @user = User.find(params[:id])
      @users = @user.followed_users.paginate(page: params[:page])
      render 'show_follow'
  end
  
  def followers
      @page_title = "Followers"
      @user = User.find(params[:id])
      @users = @user.followers.paginate(page: params[:page])
      render 'show_follow'
  end
  
  private
  
    def set_user
        @user = User.find(params[:id])
    end
  
    def user_params
  #      params.require(:user).permit!
      params.require(:user).permit(:name, :email, :password, :password_confirmation)
    end
    
    def correct_user
        redirect_to(root_path) unless current_user?(@user)
    end
    
    def admin_user
        redirect_to(root_path) unless current_user.admin?
    end
    
    def signed_in_needless_togo
        redirect_to(root_path) if signed_in?
    end
end
