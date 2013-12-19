class LastNewsMailer < ActionMailer::Base
  default from: "unbecinema@gmail.com"

  def news(user)
    @user = user
    mail(to: @user.email, subject: t(:WEEKLY_NEWS))
  end
end
