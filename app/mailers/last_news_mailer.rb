class LastNewsMailer < ActionMailer::Base
  default from: "unbecinema@gmail.com"

  def news(user)
    @user = user
    @articles = Article.approved(user).where(created_at: {'$gte' => 1.week.ago})
    mail(to: @user.email, subject: t(:WEEKLY_NEWS))
  end
end
