# frozen_string_literal: true

require "test_helper"

module Noodle
  class ChatTest < ActiveSupport::TestCase
    test "factory creates DummyChat in test environment" do
      assert_kind_of DummyChat, Chat.create
    end

    test "factory creates LlmChat with instructions" do
      Rails.configuration.with(noodle: { chat: :llm, instructions: "You're Noodle!" }) do
        noodle_chat = Chat.create

        assert_kind_of LlmChat, noodle_chat

        chat = noodle_chat.instance_variable_get(:@chat)
        assert_kind_of RubyLLM::Chat, chat

        message = chat.messages.first
        assert_equal :system, message.role
        assert_equal Rails.configuration.noodle[:instructions], message.content
      end
    end

    test "DummyChat ask responds with JSON to YAML message" do
      response_json = DummyChat.new.ask(<<-YAML
        foo-gem:
        bar-gem:
      YAML
      )

      response_hash = ActiveSupport::JSON.decode response_json

      assert_equal %w[foo-gem bar-gem], response_hash["gems"]
    end
  end
end
