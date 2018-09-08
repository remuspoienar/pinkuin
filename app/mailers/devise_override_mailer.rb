class DeviseOverrideMailer < Devise::Mailer
  helper :application
  include Devise::Controllers::UrlHelpers

  default template_path: 'devise/mailer'

  default from: "Pinkuin app <app@#{ENV['SMTP_DOMAIN']}>"
  default reply_to: "no reply <no-reply@#{ENV['SMTP_DOMAIN']}>"
end