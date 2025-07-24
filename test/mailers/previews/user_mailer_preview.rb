# Preview all emails at http://localhost:3000/rails/mailers/user_mailer
class UserMailerPreview < ActionMailer::Preview
  # Preview this email at http://localhost:3000/rails/mailers/user_mailer/confirm_email
  def confirm_email
    user = User.new(email_address: "dude@metal.com")
    UserMailer.with(user:).confirm_email
  end
end
