# frozen_string_literal: true

class CreateProject
  def self.create
    new(Noodle::Chat.create, 3)
  end

  def initialize(chat, rubygem_count)
    @chat = chat
    @rubygem_count = rubygem_count
  end

  def call
    parse_response(@chat.ask(chat_prompt(random_gems))) => { gems:, prompt:, difficulty: }

    rubygems = gems.map { Rubygem.find_by(name: it) }

    Project.new(rubygems:, prompt:)
  end

  private
    def random_gems
      Rubygem.order("RANDOM()").limit(@rubygem_count).to_a
    end

    def chat_prompt(rubygems)
      rubygems.each_with_object({}) do |rubygem, hash|
        hash[rubygem.name] = {
          "description" => rubygem.description,
          "homepage_url" => rubygem.homepage_url
        }
      end.to_yaml
    end

    def parse_response(content)
      content = content
        .delete_prefix("```json") # sometimes included despite system prompt
        .delete_suffix("```") # idem ditto

      ActiveSupport::JSON.decode(content).symbolize_keys
    end
end
