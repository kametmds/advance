class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user, only: [:index, :edit, :update, :destroy]

  def index
    @users = User.all
  end

  def show
  end

  def new
    if params[:back]
      @user = User.new(user_params)
    else
      @user = User.new
    end
  end

  def edit
  end

  def create
    @user = User.new(user_params)
    if @user.save
      redirect_to user_path(@user.id)
      flash[:notice] = 'ユーザー登録しました'
    else
      render 'new'
    end
  end

  def update
    if @user.update(user_params)
      redirect_to user_path(@user.id)
      flash[:notice] = '編集しました'
    else
      render :edit
    end
  end

  def destroy
    @user.destroy
    redirect_to users_path
    flash[:notice] = '削除しました'
  end

  def confirm
    @user = User.new(user_params)
    render :new if @user.invalid?
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:name, :email, :image, :image_cache, :password, :password_confirmation)
  end
end
