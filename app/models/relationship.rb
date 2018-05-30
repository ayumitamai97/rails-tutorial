class Relationship < ApplicationRecord
  belongs_to :follower, class_name: "User"
  belongs_to :followed, class_name: "User"
  validates :followed_id, presence: true # Rails5ではこのバリデーションいらない
  validates :follower_id, presence: true
end
