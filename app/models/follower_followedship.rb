class FollowerFollowedship < ActiveRecord::Base
    belongs_to :follower, class_name: "User"
    belongs_to :followed, class_name: "User"
        #把user模擬成有兩個，一個是follower一個是followed
    validates :follower_id, presence: true
    validates :followed_id, presence: true
end
