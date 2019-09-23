class FeedsController < ApplicationController
  before_action :set_feed, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user
  before_action :forbid_correct_user, only: [:edit, :update, :destroy]
  
  def index
    @feeds = Feed.all
  end

  def show
  end

  def new
    if params[:back]
      @feed = Feed.new(feed_params)
    else
      @feed = Feed.new
    end
  end

  def edit
  end

  def create
    @feed = current_user.feeds.build(feed_params)
    if @feed.save
      redirect_to @feed, notice: '投稿しました'
    else
      render :new
    end
  end

  def update
    if @feed.update(feed_params)
      redirect_to @feed, notice: '編集しました'
    else
      render :edit
    end
  end

  def destroy
    @feed.destroy
    redirect_to feeds_url, notice: '削除しました'
  end

  def confirm
    @feed = current_user.feeds.build(feed_params)
    render :new if @feed.invalid?
  end

  private

  def set_feed
    @feed = Feed.find(params[:id])
  end

  def feed_params
    params.require(:feed).permit(:image,:image_cache, :content)
  end

end
