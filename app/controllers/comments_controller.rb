class CommentsController < ApplicationController
  def create
    # Feedをパラメータの値から探し出し,Feedに紐づくcommentsとしてbuildします。
    @feed = Feed.find(params[:feed_id])
    @comment = @feed.comments.build(comment_params)
    respond_to do |format|
      if @comment.save
        format.js { render :index }
      else
        format.html { redirect_to feed_path(@feed), notice: '投稿出来ませんでした...' }
      end
    end
  end

  def destroy
    @comment = Comment.find(params[:id])
    if @comment.destroy
      render :index, notice: '削除しました'
    end
  end
  private

  def comment_params
    params.require(:comment).permit(:feed_id, :content, :user_id)
  end

end
