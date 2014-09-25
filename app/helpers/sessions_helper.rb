module SessionsHelper
    
    def sign_in(user)
        remember_token = User.new_remember_token
        cookies.permanent[:remember_token] = remember_token
            #等同於 cookies[:remember_token] = { value: remember_token, expires: 20.years.from_now.utc }
            #Rails的permanent方法會自動把cookie的失效日期設為20年後。
        user.update_attribute(:remember_token, User.hash(remember_token))
        self.current_user = user    #等於 current_user=(user)
    end
    
    def signed_in?
        !current_user.nil?
    end
    
    def current_user=(user)
        @current_user = user    #將@current賦值，只在登入時執行一次。
    end
    
    def current_user
        remember_token = User.hash(cookies[:remember_token])
        @current_user ||= User.find_by(remember_token: remember_token)  #等同 @current_user = @current_user || User.find_by(remember_token: remember_token)
        # 一旦使用者轉到其他頁面，@current_user會消失，所以要加個||=User.find_by，如果不存在就從資料庫重抓
    end
    
    def sign_out
        current_user.update_attribute(:remember_token, User.hash(User.new_remember_token))
        self.current_user = nil
        cookies.delete(:remember_token)
    end
    
end
