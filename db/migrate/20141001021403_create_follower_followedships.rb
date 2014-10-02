class CreateFollowerFollowedships < ActiveRecord::Migration
  def change
    create_table :follower_followedships do |t|
      t.integer :follower_id
      t.integer :followed_id
      t.timestamps
    end
    add_index :follower_followedships, :follower_id
    add_index :follower_followedships, :followed_id
    add_index :follower_followedships, [:follower_id, :followed_id], unique: true
        #確保follower_id, followed_id組合唯一
  end
end
