class UserMailer < ApplicationMailer
  before_action :set_user

  def confirm_email
    mail to: @user.email_address, subject: "Confirm your email address to start Gemming"
  end

  private

    def set_user
      @user = params[:user]
    end
end
