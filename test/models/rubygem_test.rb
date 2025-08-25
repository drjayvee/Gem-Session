require "test_helper"

class RubygemTest < ActiveSupport::TestCase
  test "attributes must be present and not nil" do
    %i[ name description homepage_url ].each do |attr|
      rubygem = Rubygem.new
      rubygem.validate

      refute_empty rubygem.errors[attr], "Expected an error for missing attribute #{attr}"

      rubygem[attr] = ""
      rubygem.validate

      refute_empty rubygem.errors[attr], "Expected an error for empty string #{attr}"
    end
  end

  test "homepage_url must be valid URI" do
    rubygem = Rubygem.new(homepage_url: "example.com")
    rubygem.validate

    refute_empty rubygem.errors[:homepage_url]
    assert_match "invalid", rubygem.errors[:homepage_url].first

    rubygem.homepage_url = "http://example.com"
    rubygem.validate

    assert_empty rubygem.errors[:homepage_url]
  end

  test "name must be unique" do
    rubygem = Rubygem.new(name: rubygems(:gemmable).name)
    rubygem.validate

    refute_empty rubygem.errors[:name]
    assert_match "been taken", rubygem.errors[:name].first
  end

  test "to_s returns name" do
    rubygem = rubygems(:gemmable)

    assert_equal rubygem.name, rubygem.to_s
  end
end
