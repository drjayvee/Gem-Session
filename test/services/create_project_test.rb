# frozen_string_literal: true

require "test_helper"
require "minitest/mock"

class CreateProjectTest < ActiveSupport::TestCase
  def setup
    @chat = Minitest::Mock.new

    @chat_response = {
      gems: rubygems.map { it.name },
      prompt: "Build stuff",
      difficulty: 5
    }

    @create_project = CreateProject.new(@chat, 2)
  end

  def teardown
    @chat.verify
  end

  test "sends message to chat containing gems" do
    @chat.expect :ask, @chat_response.to_json do |message|
      gems = YAML.safe_load(message)

      assert_equal 2, gems.keys.size
      assert_equal @chat_response[:gems].sort, gems.keys.sort
      gems.each_pair do |name, attributes|
        rubygem = rubygems name.to_sym

        assert_equal(
          { description: rubygem.description, homepage_url: rubygem.homepage_url },
          attributes.symbolize_keys
        )
      end
    end

    @create_project.call
  end

  test "parses response" do
    @chat.expect :ask, @chat_response.to_json, [ String ]

    project = @create_project.call

    assert_equal @chat_response[:gems].sort, project.rubygems.map(&:name).sort
    assert_equal @chat_response[:prompt], project.prompt
  end

  test "ignores ```json ... ``` in response" do
    @chat.expect :ask, "```json#{@chat_response.to_json}```", [ String ]

    @create_project.call
  rescue Exception => e
    flunk "Error while parsing response: #{e}"
  end
end
