require "test_helper"

class ProjectTest < ActiveSupport::TestCase
  test "prompt muse be present" do
    project = Project.new
    project.validate

    refute_empty project.errors[:prompt]
    assert_match "blank", project.errors[:prompt].first

    project.prompt = "Build this"
    project.validate

    assert_empty project.errors[:prompt]
  end

  test "repo_url may be blank" do
    project = Project.new
    project.validate

    assert_empty project.errors[:repo_url]
  end

  test "repo_url must be valid URI" do
    project = Project.new(repo_url: "example.com")
    project.validate

    refute_empty project.errors[:repo_url]
    assert_match "invalid", project.errors[:repo_url].first

    project.repo_url = "http://example.com"
    project.validate

    assert_empty project.errors[:repo_url]
  end
end
