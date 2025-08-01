require "test_helper"

class UserTest < ActiveSupport::TestCase
  test "email_address is required" do
    user = User.new
    user.validate

    refute_empty user.errors[:email_address]

    user.email_address = "me@hey.com"
    user.validate

    assert_empty user.errors[:email_address]
  end

  test "email_address is normalized" do
    email_address = " Me@HeY.com "
    assert_equal "me@hey.com", User.new(email_address:).email_address
  end

  test "email_address must be valid" do
    user = User.new

    %w[@hey jay@].each do |email_address|
      user.email_address = email_address
      user.validate

      refute_empty user.errors[:email_address], "email address '#{email_address}' should be invalid"
    end

    user.email_address = "me@hey.com"
    user.validate

    assert_empty user.errors[:email_address]
  end

  test "email_address must be unique" do
    assert_raises ActiveRecord::RecordInvalid, match: "address has already been taken" do
      User.create! email_address: users(:jay).email_address, password: "secret"
    end
  end

  test "new user has confirmation_token, is not confirmed" do
    user = User.new

    assert_not_empty user.confirmation_token
    refute user.confirmed?
  end

  test "can confirm with valid token" do
    user = User.create!(email_address: "me@hey.com", password: "it's me")
    user.confirm!

    assert_nil user.confirmation_token
    assert user.confirmed?
    assert_in_delta Time.current, user.confirmed_at, 1.second
  end
end
