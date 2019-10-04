class MessagesController < ApplicationController
  before_action do
    @conversation = Conversation.find(params[:conversation_id])
  end

  def index
    @messages = @conversation.messages

    if @messages.length > 10
      @over_ten = true
      #直近で登録されたメッセージの10件のidを取得し、そのidのmessageの配列をwhereメソッドで取得する.pluckはテーブルからカラムを取得する。
      #@messages[-10..-1]のような形でmessageの配列を取り出してしまうと、RailsのDB操作の機能を持ったActiveRecord_Relationというクラスが、ただのArrayクラスへと変換されてしまう。
      #そのため、whereなどのメソッドが使用できなくなってしまいます。
      #なので直近で登録されたメッセージの10件のidを取得し、そのidのmessageの配列をwhereメソッドで取得するという、少々回りくどい操作をここでは行なっています。
      @messages = Message.where(id: @messages[-10..-1].pluck(:id))
    end

    #params[:m]というのは、link_toにオプションで追記するクエリパラメータ,そこに値があればtrue
    if params[:m]
      @over_ten = false
      @messages = @conversation.messages
    end

    #もし最新（最後）のメッセージが存在し、かつユーザIDが自分（ログインユーザ）でなければ、今映っているメッセージを全て既読にする
    #lastメソッドは、配列の最後の要素を返し空のときはnilを返す、というRubyのメソッド
    if @messages.last
      @messages.where.not(user_id: current_user.id).update_all(read: true)
    end

    #表示するメッセージを作成日時順（投稿された順）に並び替える
    @messages = @messages.order(:created_at)

    #新規投稿のメッセージ用の変数を作成する
    #buildはnewとほぼ同じ内容の処理をしますが、慣習的に「すでにアソシエーションしてあるインスタンスの生成」ということを表します。
    @message = @conversation.messages.build
  end

  def create
    #送られてきたparamsの値を利用して会話にひもづくメッセージを生成
    @message = @conversation.messages.build(message_params)
    if @message.save
      #保存ができれば、会話にひもづくメッセージ一覧の画面（つまりチャットルーム）に遷移する
      redirect_to conversation_messages_path(@conversation)
    else
      render 'index'
    end
  end

  private

  def message_params
    params.require(:message).permit(:body, :user_id)
  end
end
