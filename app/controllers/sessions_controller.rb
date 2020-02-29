class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.find by(email: params[:session][:email].douncase)
    if user && user.authenticate(params[:session][:password])
      session[:user_id] = user.id
      redirecr_to user_path(user.id)
    else
      flash[:danger] = 'ログインに失敗しました'
      render :new
    end 
  end

  def destroy
    session.delete(:user id)
    flash[:notice] = 'ログアウトしました'
    redirect_to new_session_path
  end
end
