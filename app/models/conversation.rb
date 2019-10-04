class Conversation < ApplicationRecord
  # 会話はUserの概念をsenderとrecipientに分けた形でアソシエーションする。
  # 会話の送り手がユーザモデルから参照できるようにアソシエーションを設定
  belongs_to :sender, foreign_key: :sender_id, class_name: 'User'
  # 会話の受け手がユーザモデルから参照できるようにアソシエーションを設定
  belongs_to :recipient, foreign_key: :recipient_id, class_name: 'User'
  # 一つの会話はメッセージをたくさん含む一対多。
  # 会話は複数のメッセージを保有し、会話が削除されたらメッセージも削除する
  has_many :messages, dependent: :destroy

  # [:sender_id, :recipient_id]が同じ組み合わせで保存されないようにするためのバリデーションを設定。validates_uniqueness_of は、属性の値が一意であることを検証するメソッド。
  validates_uniqueness_of :sender_id, scope: :recipient_id

  # scopeを使えば、SQL文をメソッド化できる。今回は「between」というスコープを定義。
  # 送り手と受け手の「組み合わせ」で判定するbetweenスコープを定義する。
  # ※betweenスコープは引数のsender_idのsenderとrecipient_idのrecipientとで、過去に会話が存在していたかどうかを確認するもの※
  scope :between, -> (sender_id,recipient_id) do
    #conversations.sender_id = ?は、conversations.sender_idが存在すればtrueを、存在しなければfalseを返す式
    #例えば引数として送られてきたsender_idが1だとしたら、Conversation.where("sender_id = '1'")）の検索条件を満たすインスタンスが実際に存在すればtrueを返します。
    #この時、ポイントとなるのは、senderとrecipientの間柄が逆でも問題がない処理にする必要があるということ
    where("(conversations.sender_id = ? AND conversations.recipient_id =?) OR (conversations.sender_id = ? AND  conversations.recipient_id =?)", sender_id,recipient_id, recipient_id, sender_id)
    #where("conversations.sender_id = ? && conversations.recipient_id =? || conversations.sender_id = ? &&  conversations.recipient_id =?", sender_id,recipient_id, recipient_id, sender_id)
  end

  # 会話の相手の情報を取得する
  # このメソッドを起動させた際のcurrent_userと、current_userの相手となるuserの情報を取得
  def target_user(current_user)
    if sender_id == current_user.id
      User.find(recipient_id)
    elsif recipient_id == current_user.id
      User.find(sender_id)
    end
  end
end
