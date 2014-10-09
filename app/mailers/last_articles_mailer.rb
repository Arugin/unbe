class LastArticlesMailer < ActionMailer::Base
  default from: "unbe@unbe.ru"

  def articles(user)
    @user = user
    @articles = Article.approved(user).where(:created_at.gt => 1.week.ago)
    mail(to: @user.email, subject: t(:WEEKLY_NEWS))
  end
end
