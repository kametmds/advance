class Message < ApplicationRecord
  belongs_to :conversation
  belongs_to :user

  validates_presence_of :body, :conversation_id, :user_id
  def message_time
    #画面上に表示させる作成日は時刻をフォーマットに従って表示する。strftime は、日付データをフォーマットするメソッド
    created_at.strftime("%m/%d/%y at %l:%M %p")
  end
end
