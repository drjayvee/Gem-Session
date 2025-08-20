require "ruby_llm"

RubyLLM.configure do |config|
  config.anthropic_api_key = ENV["ANTHROPIC_API_KEY"]
  config.default_model = "claude-3-5-haiku"

  config.logger = Rails.logger
  config.log_level = Rails.env.production? ? :info : :debug
  config.request_timeout = Rails.env.production? ? 120 : 30
end
