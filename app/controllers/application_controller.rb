class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  include SessionsHelper

  private

  #ログインユーザーと編集しようとしているユーザーのidが一致しない場合にアクセスを拒否
  def ensure_correct_user
    if current_user.id != params[:id].to_i
      flash[:notice] = "権限がありません"
      redirect_to users_path
    end
  end

  #ログインユーザーと編集しようとしている投稿のユーザーidが一致しない場合にアクセスを拒否
  def forbid_correct_user
    if current_user.id != @feed.user.id
      flash[:notice] = "編集権限がありません"
      redirect_to feeds_path
    end
  end

  #ログアウト状態の時アクセス拒否
  def authenticate_user
    if current_user == nil
      flash[:notice] = "ログインが必要です"
      redirect_to new_session_path
    end
  end

end
