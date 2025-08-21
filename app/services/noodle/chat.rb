# frozen_string_literal: true

module Noodle
  class Chat
    def self.create
      case Rails.configuration.noodle[:chat].to_sym
      when :llm
        LlmChat.new(Rails.configuration.noodle[:instructions])
      when :dummy
        DummyChat.new
      else
        raise "Unknown Chat type #{Rails.configuration.noodle[:chat]}"
      end
    end

    def ask(message)
      raise NotImplementedError
    end
  end
end
