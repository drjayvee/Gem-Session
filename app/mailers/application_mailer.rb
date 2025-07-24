class ApplicationMailer < ActionMailer::Base
  default from: "noodle@#{Rails.application.config.action_mailer.default_url_options[:host]}"
  layout "mailer"
end
