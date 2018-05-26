class Micropost < ApplicationRecord
  belongs_to :user # migration file生成時にadd_indexするとこの行が自動生成される
  validates :user_id, presence: true
  validates :content, presence: true, length: {maximum: 140}
end
