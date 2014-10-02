class User < ActiveRecord::Base
    has_many :microposts, dependent: :destroy
    
    has_many :follower_followedships, foreign_key: "follower_id", dependent: :destroy
        #之所以要告知外鍵，是因為follower_followedships，沒有user_id這東西，
        #因為這關聯是AAA對AAA，而不是AAA對BBB，所以沒辦法用user_id，要另外用名字
    has_many :followed_users, through: :follower_followedships, source: :followed
        #本來應該是has_many :followeds, through: :follower_followedships，Rails就會找followed_id
        #但是user.followed_users比user.followeds更好表達使用者所關注的用戶，所以改變名稱，以source告知正確來源id陣列
    
    has_many :reverse_follower_followedships, foreign_key: "followed_id", class_name: "FollowerFollowedship", dependent: :destroy
        #reverse_follower_followedships是個虛擬表，就是把follower_id和followed_id位置對調而已
        #如果不指定class，Rails會去找ReverseFollowerFollwedship這個class，但是並不存在
    has_many :followers, through: :reverse_follower_followedships, source: :follower
        #這裡的source是可以不用指定的，因為沒有改名稱，Rails會自己找follower_id
        #user.followers就是關注自己的人，就是粉絲
        
    before_save { self.email = email.downcase } #有的資料庫無法區分大小寫，所以為了確保唯一，只好存進去之前都轉成小寫
    before_create :create_remember_token
    
    validates :name, presence: true, length: { maximum: 50 }
    VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i
    validates :email, presence: true, 
                     format: { with: VALID_EMAIL_REGEX }, 
                     uniqueness: { case_sensitive: false }
    has_secure_password  #相當神奇的一行，只要資料庫有password_digest，他就會驗證身分，自動創建password和password_confirmation屬性
    validates :password, length: { minimum: 6 }
    
    def User.new_remember_token
        SecureRandom.urlsafe_base64
    end
    
    def User.hash(token)
        Digest::SHA1.hexdigest(token.to_s)
    end
    
    def feed
#        Micropost.where("user_id = ?", id)   //等於microposts
        Micropost.from_users_followed_by(self)
    end
    
    def following?(other_user)
        follower_followedships.find_by(followed_id: other_user.id)
            #本來該是self.follower_followedships...，省略了自己
    end
    
    def follow!(other_user)
        follower_followedships.create!(followed_id: other_user.id)
    end
    
    def unfollow!(other_user)
        follower_followedships.find_by(followed_id: other_user.id).destroy
    end
    
    private
        def create_remember_token
            self.remember_token = User.hash(User.new_remember_token)
        end
    
end
