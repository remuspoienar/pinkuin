# Preview all emails at http://localhost:3000/rails/mailers/devise_override_mailer

class DeviseOverrideMailerPreview < ActionMailer::Preview

  def confirmation_instructions_preview
    DeviseOverrideMailer.confirmation_instructions(User.last, 'Token1234$')
  end

end
