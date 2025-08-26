# frozen_string_literal: true

require "redcarpet"

module ApplicationHelper
  def markdown(text)
    markdown = Redcarpet::Markdown.new(
      Redcarpet::Render::HTML,
      filter_html: true, no_images: true, no_links: true, no_styles: true
    )
    markdown.render(text).html_safe
  end
end
