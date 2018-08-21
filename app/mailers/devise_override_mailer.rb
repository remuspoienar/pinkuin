class DeviseOverrideMailer < Devise::Mailer
  helper :application
  include Devise::Controllers::UrlHelpers

  default template_path: 'devise/mailer'

  default from: 'Pinkuin app <app@pinkuin.xyz>'
  default reply_to: 'Pinkuin app <no-reply@pinkuin.xyz>'
end