class User < ApplicationRecord
  before_save { self.email = email.downcase } # データベースが大文字小文字を区別してしまう場合に備える callback
  validates :name, presence: true, length: { maximum: 50 }

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, length: { maximum: 255 },
   format: { with: VALID_EMAIL_REGEX },
   # uniqueness: true # 一意性
   uniqueness: { case_sensitive: false } # 大文字小文字を区別しない # 一意性
end
