class Micropost < ActiveRecord::Base
  belongs_to :user
  default_scope -> { order('created_at DESC') }
  validates :content, presence: true, length: { maximum: 140 }
  validates :user_id, presence: true
  
    def self.from_users_followed_by(user)   #不加self會找不到method，為什麼要加= =
#        followed_user_ids = user.followed_user_ids
            #user.followed_user_ids 等於 user.followed_users.map($:id) 等於 user.followed_users.map { |i| i.id }
#        where("user_id IN (?) OR user_id = ?", followed_user_ids, user)

        followed_user_ids = "SELECT followed_id FROM follower_followedships
                             WHERE follower_id = :user_id"
            #上面的方法是透過使用者關注的所有用戶，一個個取得id；這裡改成直接去DB抓要的id陣列
        where("user_id IN (#{followed_user_ids}) OR user_id = :user_id", user_id: user.id)
            #用問號的方式插入值也行，這裡的方式適用於要在多處插入同一值的情形
    end
end
