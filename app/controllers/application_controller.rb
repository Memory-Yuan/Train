class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  include SessionsHelper
  #默認情況下幫助函數只可以在View中使用，不能在Controller中使用，
  #，所以我們就手動引入幫助函數所在的模塊。
end
