class UsersController < ApplicationController
  allow_unauthenticated_access only: %i[ new create confirm_email ]

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)

    if @user.save
      UserMailer.with(user: @user).confirm_email.deliver_later
      redirect_to root_path, notice: "Please confirm your email address before continuing. Check your mail box!"
    else
      redirect_to new_user_path, alert: @user.errors.full_messages
    end
  end

  def confirm_email
    user = User.find_by(confirmation_token: params[:token])

    if user
      user.confirm!
      redirect_to root_path, notice: "Thanks for confirming your email address. Now let's gem! 🤘"
    else
      redirect_to root_path, alert: "Invalid token provided. Perhaps you've already confirmed your email address?"
    end
  end

  private

    def user_params
      params.expect(user: [ :email_address, :password, :password_confirmation ])
    end
end
