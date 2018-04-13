class User < ApplicationRecord
  attr_accessor :remember_token # クラスやモジュールにインスタンス変数を読み書きするためのアクセサメソッドを定義
  # update_attributeのため

  # before_save { self.email = email.downcase } # データベースが大文字小文字を区別してしまう場合に備える callback
  before_save { email.downcase! } # 上と同値。 .downcase!とするときはselfをつけなくてよい
  validates :name, presence: true, length: { maximum: 50 }

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, length: { maximum: 255 },
    format: { with: VALID_EMAIL_REGEX },
    # uniqueness: true # 一意性
    uniqueness: { case_sensitive: false } # 大文字小文字を区別しない # 一意性
    validates :password, presence: true, length: { minimum: 6 }, allow_nil: true
    has_secure_password
    # 新規ユーザー登録時に空のパスワードが有効になってしまうのかと心配になるかもしれませんが、安心してください。6.3.3で説明したように、has_secure_passwordでは (追加したバリデーションとは別に) オブジェクト生成時に存在性を検証するようになっているため、空のパスワード (nil) が新規ユーザー登録時に有効になることはありません。(空のパスワードを入力すると存在性のバリデーションとhas_secure_passwordによるバリデーションがそれぞれ実行され、2つの同じエラーメッセージが表示されるというバグがありましたが (7.3.3)、これで解決できました。)


    class << self
      def digest(string) # self.digest(string)としてもよいが…
        cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :  BCrypt::Engine.cost # has_secure_passwordのスクリプトからコピペ
        BCrypt::Password.create(string, cost: cost) # 上に同じ
      end

      def new_token # self.new_tokenとしてもよいが…
        SecureRandom.urlsafe_base64 # random tokenを返す、Ruby標準ライブラリのSecureRandomモジュールにあるurlsafe_base64メソッド
      end
    end

    def remember # 永続セッションのためにユーザをDBに記憶させる
      self.remember_token = User.new_token # 最初に記憶トークンを更新
      update_attribute(:remember_digest, User.digest(remember_token)) # attr_accessorが活きる
      # remember_tokenはpasswordのようなもの、remember_digestはpassword_digestのようなもの
    end

    def authenticated?(remember_token)
      return false if remember_digest.nil? # browserダブり対策
      # 一度forget=logoutされたらauthenticatedと判断されないようにする
      BCrypt::Password.new(remember_digest).is_password?(remember_token)
    end

    def forget # 記憶トークンの破棄
      update_attribute(:remember_digest, nil)
    end


end
