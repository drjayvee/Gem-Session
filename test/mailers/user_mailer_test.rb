require "test_helper"

class UserMailerTest < ActionMailer::TestCase
  include Rails.application.routes.url_helpers

  def setup
    @default_url_options = { host: "gem-session.site" }
  end

  test "confirm_email" do
    user = User.new(email_address: "dude@metal.com")

    mail = UserMailer.with(user:).confirm_email
    assert_equal "Confirm your email address to start Gemming", mail.subject
    assert_equal [ user.email_address ], mail.to
    assert_equal [ "noodle@gem-session.site" ], mail.from
    assert_match confirm_user_email_url(token: user.confirmation_token), mail.body.encoded
  end
end
