class StaticPagesController < ApplicationController
  def home
      @page_title = "Home"
      if signed_in?
          @micropost = current_user.microposts.build
          @feed_items = current_user.feed.paginate(page: params[:page])
      end
  end

  def help
      @page_title = "Help"
  end
  
  def about
      @page_title = "About"
  end
  
  def contact
      @page_title = "Contact"
  end
end
