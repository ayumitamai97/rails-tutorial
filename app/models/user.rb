class User < ApplicationRecord
  # before_save { self.email = email.downcase } # データベースが大文字小文字を区別してしまう場合に備える callback
  before_save { email.downcase! } # 上と同値。 .downcase!とするときはselfをつけなくてよい
  validates :name, presence: true, length: { maximum: 50 }

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, length: { maximum: 255 },
    format: { with: VALID_EMAIL_REGEX },
    # uniqueness: true # 一意性
    uniqueness: { case_sensitive: false } # 大文字小文字を区別しない # 一意性
    validates :password, presence: true, length: { minimum: 6 }
    has_secure_password

    def User.digest(string)
      cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :  BCrypt::Engine.cost # has_secure_passwordのスクリプトからコピペ
      BCrypt::Password.create(string, cost: cost) # 上に同じ
    end

end
