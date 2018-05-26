class User < ApplicationRecord
  has_many :microposts, dependent: :destroy # userが消されるとmicropostも消される
  attr_accessor :remember_token, :activation_token, :reset_token
  # クラスやモジュールにインスタンス変数を読み書きするためのアクセサメソッドを定義
  # update_attributeのため

  # before_save { self.email = email.downcase } # データベースが大文字小文字を区別してしまう場合に備える callback
  before_save { downcase_email } # 上と同値。 .downcase!とするときはselfをつけなくてよい
  before_create :create_activation_digest # これをcallbackのメソッド参照という
  # 多くの場合、各メソッド内で重複する動作をまとめるために使う
  validates :name, presence: true, length: { maximum: 50 }


  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, length: { maximum: 255 },
    format: { with: VALID_EMAIL_REGEX },
    # uniqueness: true # 一意性
    uniqueness: { case_sensitive: false } # 大文字小文字を区別しない # 一意性
    validates :password, presence: true, length: { minimum: 6 }, allow_nil: true
    has_secure_password
    # 新規ユーザー登録時に空のパスワードが有効になってしまうのかと心配になるかもしれませんが、安心してください。6.3.3で説明したように、has_secure_passwordでは (追加したバリデーションとは別に) オブジェクト生成時に存在性を検証するようになっているため、空のパスワード (nil) が新規ユーザー登録時に有効になることはありません。(空のパスワードを入力すると存在性のバリデーションとhas_secure_passwordによるバリデーションがそれぞれ実行され、2つの同じエラーメッセージが表示されるというバグがありましたが (7.3.3)、これで解決できました。)

    def activate
      update_columns(activated: true, activated_at: Time.zone.now)
    end

    def send_activation_email
      UserMailer.account_activation(self).deliver_now
    end

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

    # consoleでユーザ作成時は`user.remember_token = User.new_token`でトークン生成
    # remember_digest生成のためには、user.update_attribute(:remember_digest, User.digest(user.remember_token))

    def authenticated?(attribute, token)
      digest = send("#{attribute}_digest")
      return false if digest.nil? # browserダブり対策
      # 一度forget=logoutされたらauthenticatedと判断されないようにする
      BCrypt::Password.new(digest).is_password?(token)
    end

    def forget # 記憶トークンの破棄
      update_attribute(:remember_digest, nil)
    end

    def send_password_reset_email # パスワード再設定のメールを送信する
      UserMailer.password_reset(self).deliver_now
    end

    def password_reset_expired?
      reset_sent_at < 2.hours.ago
    end

    def create_reset_digest
      self.reset_token = User.new_token # reset_tokenを定義
      update_columns(reset_digest: User.digest(reset_token), reset_sent_at: Time.zone.now)
    end

    private
      def downcase_email
        email.downcase!
      end
      def create_activation_digest
        self.activation_token  = User.new_token
        self.activation_digest = User.digest(activation_token)
      end

end
