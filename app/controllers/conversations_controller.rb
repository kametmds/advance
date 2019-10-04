class ConversationsController < ApplicationController

  def index
    @conversations = Conversation.all
  end

  def create
    if logged_in?
      #該当のユーザ間での会話が過去に存在しているか（該当ユーザー間で会話をするためのチャットルームがすでに存在しているか）を確認する式
      if Conversation.between(params[:sender_id], params[:recipient_id]).present?
        #その会話（チャットルーム）情報を取得します。
        @conversation = Conversation.between(params[:sender_id], params[:recipient_id]).first
      else
        #強制的に会話（チャットルーム）情報を生成
        @conversation = Conversation.create!(conversation_params)
      end
      #いずれの状態であってもその後その会話に紐づくメッセージの一覧画面へ遷移させる式
      redirect_to conversation_messages_path(@conversation)
    else
      redirect_to root_path
    end
  end

  private

  def conversation_params
    params.permit(:sender_id, :recipient_id)
  end
end
