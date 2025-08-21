# frozen_string_literal: true

module Noodle
  class DummyChat < Chat
    def ask(message)
      gems = YAML.safe_load(message).keys

      {
        gems:,
        prompt: "Build something *awesome* with these instruments",
        difficulty: 3.0
      }.to_json
    end
  end
end
