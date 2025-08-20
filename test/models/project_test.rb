require "test_helper"

class ProjectTest < ActiveSupport::TestCase
  test "user must be present" do
    project = Project.new
    project.validate

    refute_empty project.errors[:user]
  end

  test "exactly two Rubygems must be associated" do
    project = projects(:one)
    project.rubygems.build name: "yep", description: "Yep", homepage_url: "https://yep.io"
    project.validate

    refute_predicate project, :valid?
    assert_match "must have exactly two, not 3", project.errors[:rubygems].first

    project.reload
    project.rubygems = [project.rubygems.first]
    project.validate

    refute_predicate project, :valid?
    assert_match "must have exactly two, not 1", project.errors[:rubygems].join
  end

  test "no duplicate Rubygems" do
    project = projects(:one)
    project.rubygems = [project.rubygems.first, project.rubygems.first]
    project.validate

    refute_predicate project, :valid?
    assert_match "must not contain duplicates", project.errors[:rubygems].first
  end

  test "prompt muse be present" do
    project = Project.new
    project.validate

    refute_empty project.errors[:prompt]
    assert_match "blank", project.errors[:prompt].first

    project.prompt = "Build this"
    project.validate

    assert_empty project.errors[:prompt]
  end

  test "homepage_url may be nil, but not blank" do
    project = Project.new homepage_url: ""
    project.validate

    refute_empty project.errors[:homepage_url]

    project.homepage_url = nil
    project.validate

    assert_empty project.errors[:homepage_url]
  end

  test "homepage_url must be valid URI" do
    project = Project.new(homepage_url: "example.com")
    project.validate

    refute_empty project.errors[:homepage_url]
    assert_match "invalid", project.errors[:homepage_url].first

    project.homepage_url = "http://example.com"
    project.validate

    assert_empty project.errors[:homepage_url]
  end
end
