class Micropost < ApplicationRecord
  belongs_to :user # migration file生成時にadd_indexするとこの行が自動生成される
  default_scope -> {order(created_at: :desc)}
  validates :user_id, presence: true
  validates :content, presence: true, length: {maximum: 140}
end
