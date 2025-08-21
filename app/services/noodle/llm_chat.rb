# frozen_string_literal: true

module Noodle
  class LlmChat < Chat
    def initialize(instructions)
      @chat = RubyLLM.chat.with_instructions instructions
    end

    def ask(message)
      @chat.ask(message).content
    end
  end
end
