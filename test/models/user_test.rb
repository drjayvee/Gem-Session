require "test_helper"

class UserTest < ActiveSupport::TestCase
  test "email_address is required" do
    user = User.new
    user.validate

    refute_empty user.errors[:email_address]

    user.email_address = "jay@hey.com"
    user.validate

    assert_empty user.errors[:email_address]
  end

  test "email_address is normalized" do
    email_address = " jAy@HeY.com "
    assert_equal "jay@hey.com", User.new(email_address:).email_address
  end

  test "email_address must be valid" do
    user = User.new

    %w[@hey jay@].each do |email_address|
      user.email_address = email_address
      user.validate

      refute_empty user.errors[:email_address], "email address '#{email_address}' should be invalid"
    end

    user.email_address = "jay@hey.com"
    user.validate

    assert_empty user.errors[:email_address]
  end
end
