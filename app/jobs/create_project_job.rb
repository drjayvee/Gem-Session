# frozen_string_literal: true

class CreateProjectJob < ApplicationJob
  queue_as :default

  def perform(streamable, user_authenticated)
    project = CreateProject.create.call

    Turbo::StreamsChannel.broadcast_replace_to(
      streamable,
      target: "new_project",
      partial: "projects/form",
      locals: { project:, user_authenticated: }
    )
  end
end
