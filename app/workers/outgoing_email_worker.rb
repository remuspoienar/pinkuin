class OutgoingEmailWorker
  include Sidekiq::Worker

  def perform(notification, user_id, *args)
    user = User.find(user_id)
    mailer_method = DeviseOverrideMailer.method(notification)
    mailer_method.call(user, *args).deliver_now
  end
end
