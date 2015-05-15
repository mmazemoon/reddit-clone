class SessionsController < ApplicationController
  def new
    @user = User.new
  end

  def create
    username = params[:user][:username]
    password = params[:user][:password]
    @user = User.find_by_credentials(username, password)

    if @user.save
      login!(@user)
      redirect_to user_url(@user)
    else
      flash.now[:errors] = "Wrong username or password"
      render :new
    end
  end

  def destroy
    logout!
    redirect_to new_session_url
  end
end
