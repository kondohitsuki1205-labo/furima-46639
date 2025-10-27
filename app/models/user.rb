class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  
  has_many :items, dependent: :destroy
  
  # 文字種の正規表現
  ZENKAKU        = /\A[ぁ-んァ-ヶ一-龥々ー]+\z/
  KATAKANA       = /\A[ァ-ヶー－]+\z/
  PASSWORD_FORMAT = /\A(?=.*[a-zA-Z])(?=.*\d)[a-zA-Z\d]+\z/ # 英字と数字を両方含む

  # 必須 + 形式チェック
  with_options presence: true do
    validates :nickname, length: { maximum: 40 }
    validates :last_name,  format: { with: ZENKAKU,  message: 'は全角（漢字・ひらがな・カタカナ）で入力してください' }
    validates :first_name, format: { with: ZENKAKU,  message: 'は全角（漢字・ひらがな・カタカナ）で入力してください' }
    validates :last_name_kana,  format: { with: KATAKANA, message: 'は全角カタカナで入力してください' }
    validates :first_name_kana, format: { with: KATAKANA, message: 'は全角カタカナで入力してください' }
    validates :birthday
  end

  # パスワードの複雑性（Deviseの長さチェックは既定で 6..128）
  validates :password,
           format: { with: PASSWORD_FORMAT, message: 'は英字と数字の両方を含めて設定してください' },
           if: :password_required?

  # 未来日を禁止（任意）
  validate :birthday_cannot_be_in_the_future
  def birthday_cannot_be_in_the_future
    return if birthday.blank?
    errors.add(:birthday, 'は未来の日付にできません') if birthday > Date.today
  end
end
